//
//  DataFilteringExample.swift
//  CombineLearning
//
//  Created by caiwanhong on 2025/9/8.
//

import Foundation
import Combine

struct DataFilteringExample {
    func run() -> AnyCancellable {
        print("=== 数据过滤示例 ===")
        
        // 1. filter：过滤 Publisher 的输出值
        // - 将数组 [1, 2, 3] 转换为 Publisher，发出 1, 2, 3
        // - filter 操作符只允许值大于 1 的元素通过，输出 2, 3
        // - Output 类型为 Int，Failure 类型为 Never（不会失败）
        let filterPublisher = [1, 2, 3].publisher
            .filter { $0 > 1 }
        
        // 2. removeDuplicates：移除重复的输出值
        // - 将数组 ["A", "A", "B"] 转换为 Publisher，发出 "A", "A", "B"
        // - removeDuplicates 操作符移除连续重复的值，输出 "A", "B"
        // - Output 类型为 String，Failure 类型为 Never
        let removeDuplicatesPublisher = ["A", "A", "B"].publisher
            .removeDuplicates()
        
        // 使用 Publishers.Merge 合并两个 Publisher 的输出
        // - Merge 要求 Output 类型一致（这里通过 .map 转换为 String）
        // - Failure 类型为 Never
        // - 为每个 Publisher 的输出添加标签，便于区分
        return Publishers.Merge(
            filterPublisher.map { "Filter: \($0)" }, // 将 Int 转换为 "Filter: 2", "Filter: 3"
            removeDuplicatesPublisher.map { "RemoveDuplicates: \($0)" } // 输出 "RemoveDuplicates: A", "RemoveDuplicates: B"
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
