//
//  MergingStreamsExample.swift
//  CombineLearning
//
//  Created by caiwanhong on 2025/9/8.
//

import Foundation
import Combine

struct MergingStreamsExample {
    
    func run() -> AnyCancellable {
        print("=== 合并流示例 ===")
        
        // 1. 创建两个数组 Publisher，发出整数值
        // - [1, 2].publisher 将数组转换为 Publisher，依次发出 1, 2
        // - Output 类型为 Int，Failure 类型为 Never（不会失败）
        let p1 = [1, 2].publisher
        let p2 = [3, 4].publisher
        
        // 2. 创建两个 PassthroughSubject，用于手动发送值
        // - p3 发出 Int 值，p4 发出 String 值
        // - Failure 类型为 Never，表示不会发出错误
        let p3 = PassthroughSubject<Int, Never>()
        let p4 = PassthroughSubject<String, Never>()
        
        // 3. merge：合并 p1 和 p2 的输出
        // - merge(with:) 将多个 Publisher 的值合并为单一事件流
        // - 按时间顺序发出所有值（1, 2, 3, 4）
        let mergePublisher = p1.merge(with: p2)
        
        // 4. combineLatest：合并 p3 和 p4 的最新值
        // - combineLatest 每次任一 Publisher 发出新值时，发出两者的最新值对
        // - Output 类型为 (Int, String)，如 (1, "A"), (2, "A"), (2, "B")
        let combineLatestPublisher = p3.combineLatest(p4)
        
        // 使用 Publishers.Merge 合并 mergePublisher 和 combineLatestPublisher
        // - 由于 Output 类型不同（Int vs (Int, String)），使用 .map 转换为 String
        // - 确保 Output 类型统一为 String，Failure 类型为 Never
        let cancellable = Publishers.Merge(
            mergePublisher.map { "Merge: \($0)" },
            combineLatestPublisher.map { "CombineLatest: \($0)" }
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
        
        // 在订阅建立后手动触发 p3 和 p4 的事件
        // - 确保 combineLatestPublisher 发出值对
        // - 按顺序发送值，模拟 (1, "A"), (2, "A"), (2, "B")
        p3.send(1)
        p4.send("A")
        p3.send(2)
        p4.send("B")
        
        // 返回 cancellable，供 ContentView 存储，管理订阅生命周期
        return cancellable
    }
}
