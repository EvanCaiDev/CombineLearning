//
//  SequenceOperationsExample.swift
//  CombineLearning
//
//  Created by caiwanhong on 2025/9/8.
//

import Foundation
import Combine

struct SequenceOperationsExample {

    func run() -> AnyCancellable {
        print("=== 序列操作示例 ===")
        
        // 创建 Publisher，从数组 [1, 2, 3, 4] 发出值
        // - Output 类型为 Int，Failure 类型为 Never（不会失败）
        let publisher = [1, 2, 3, 4].publisher
        
        // 使用 first(where:) 查找第一个满足条件的元素
        // - first(where: { $0 > 2 }) 查找第一个大于 2 的值，输出 3
        // - map 将结果转换为带标签的字符串 "First: 3"
        // - 找到第一个值后，Publisher 完成，不再处理后续值
        return publisher
            .first(where: { $0 > 2 })
            .map { "First: \($0)" }
            // 使用 sink 订阅处理结果
            // - receiveCompletion：处理完成事件（.finished 或 .failure）
            // - receiveValue：处理发出的值并打印
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
