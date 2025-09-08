//
//  ErrorHandlingExample.swift
//  CombineLearning
//
//  Created by caiwanhong on 2025/9/8.
//

import Foundation
import Combine

struct ErrorHandlingExample {

    func run() -> AnyCancellable {
        print("=== 错误处理示例 ===")
        
        // 创建 PassthroughSubject，允许手动发送值或错误
        // - Output 类型为 String，Failure 类型为 Error（可发出错误）
        let publisher = PassthroughSubject<String, Error>()
        
        // 1. catch：捕获错误并替换为新的 Publisher
        // - 如果 publisher 发出错误，替换为 Just("Fallback")，将 Failure 类型转换为 Never
        let catchPublisher = publisher
            .catch { _ in Just("Fallback") }
        
        // 2. replaceError：用指定值替换错误
        // - 如果 publisher 发出错误，直接输出 "Default"，将 Failure 类型转换为 Never
        let replaceErrorPublisher = publisher
            .replaceError(with: "Default")
        
        // 3. retry：重试指定次数
        // - 如果 publisher 发出错误，尝试重新订阅 1 次
        // - 使用 .catch 将可能的错误替换为 Just("Retry Failed")，确保 Failure 类型为 Never
        let retryPublisher = publisher
            .retry(1)
            .catch { _ in Just("Retry Failed") }
        
        // 使用 Publishers.Merge3 合并三个 Publisher 的输出
        // - Merge3 要求 Output（String）和 Failure（Never）类型一致
        // - 每个 Publisher 使用 .map 添加标签，便于区分输出
        let cancellable = Publishers.Merge3(
            catchPublisher.map { "Catch: \($0)" },
            replaceErrorPublisher.map { "ReplaceError: \($0)" },
            retryPublisher.map { "Retry: \($0)" }
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
        
        // 在订阅建立后手动触发错误
        // - 发送一个错误事件，测试错误处理操作符
        publisher.send(completion: .failure(NSError(domain: "", code: -1)))
        
        // 返回 cancellable，供 ContentView 存储，管理订阅生命周期
        return cancellable
    }
}
