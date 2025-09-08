//
//  DataTransformationExample.swift
//  CombineLearning
//
//  Created by caiwanhong on 2025/9/8.
//

import Foundation
import Combine

struct DataTransformationExample {
    // run 方法运行示例，返回 AnyCancellable 用于管理订阅生命周期
    func run() -> AnyCancellable {
        print("=== 数据转换示例 ===")
        
        // 1. map：转换 Publisher 的输出值
        // - 将数组 [1, 2, 3] 转换为 Publisher，发出 1, 2, 3
        // - map 操作符将每个值乘以 2，输出 2, 4, 6
        // - Output 类型为 Int，Failure 类型为 Never（不会失败）
        let mapPublisher = [1, 2, 3].publisher
            .map { $0 * 2 }
        
        // 2. flatMap：将每个值转换为新的 Publisher 并展平结果
        // - 将数组 ["A", "B"] 转换为 Publisher，发出 "A", "B"
        // - flatMap 将每个值转换为 Just Publisher，添加 "1"，输出 "A1", "B1"
        // - Output 类型为 String，Failure 类型为 Never
        let flatMapPublisher = ["A", "B"].publisher
            .flatMap { Just($0 + "1") }
        
        // 3. scan：对值进行累积转换
        // - 将数组 [1, 2, 3] 转换为 Publisher，发出 1, 2, 3
        // - scan 从初始值 0 开始，累加每个值，输出 1, 3, 6
        // - Output 类型为 Int，Failure 类型为 Never
        let scanPublisher = [1, 2, 3].publisher
            .scan(0, +)
        
        // 使用 Publishers.Merge3 合并三个 Publisher 的输出
        // - Merge3 要求 Output 类型一致（这里通过 .map 转换为 String）
        // - Failure 类型为 Never
        // - 为每个 Publisher 的输出添加标签，便于区分
        return Publishers.Merge3(
            mapPublisher.map { "Map: \($0)" }, // 将 Int 转换为 "Map: 2", "Map: 4", "Map: 6"
            flatMapPublisher.map { "FlatMap: \($0)" }, // 输出 "FlatMap: A1", "FlatMap: B1"
            scanPublisher.map { "Scan: \($0)" } // 将 Int 转换为 "Scan: 1", "Scan: 3", "Scan: 6"
        )
        // 使用 sink 订阅合并后的 Publisher
        // - receiveCompletion：处理完成事件（.finished 或 .failure）
        // - receiveValue：处理每个发出的值并打印
        .sink(
            receiveCompletion: { completion in
                print("完成: \(completion)")
            },
            receiveValue: { value in
                print(value)
            }
        )
    }
}
