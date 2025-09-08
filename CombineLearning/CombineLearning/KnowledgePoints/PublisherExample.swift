//
//  PublisherExample.swift
//  CombineLearning
//
//  Created by caiwanhong on 2025/9/8.
//

import Foundation
import Combine

struct PublisherExample {
    // run 方法运行示例，返回 AnyCancellable 用于管理订阅生命周期
    // AnyCancellable 就是 Combine 订阅的“生命管理器”，它负责控制订阅的生命周期，释放或取消订阅时自动断开 Publisher 和 Subscriber 的连接。
    func run() -> AnyCancellable {
        // 打印标题，方便在控制台区分此示例的输出
        print("=== Publisher 示例 ===")
        
        // 1. Just：创建发出单一值的 Publisher
        // - Just 接受一个值（这里是 "Hello"），发出后立即完成
        // - 输出类型 (Output) 是 String，失败类型 (Failure) 是 Never（不会失败）
        let justPublisher = Just("Hello")
        
        // 2. Future：创建异步操作的 Publisher
        // - Future 执行一个闭包，发出一个值或错误
        // - 这里使用 DispatchQueue.global().async 模拟异步任务（如网络请求）
        // - promise 是用于发送成功值或错误的闭包
        let futurePublisher = Future<String, Error> { promise in
            DispatchQueue.global().async {
                // 发送成功结果 "Async Result"
                promise(.success("Async Result"))
            }
        }
        
        // 3. Timer.publish：创建定时发出事件的 Publisher
        // - 每 1 秒在主线程发出当前时间（Date 类型）
        // - on: .main 指定主线程，适合 UI 更新
        // - in: .common 指定运行循环模式，通常使用默认值
        // - .autoconnect() 使定时器在订阅时自动启动
        let timerPublisher = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
        
        // 4. PassthroughSubject：手动发送值的 Publisher
        // - 没有初始值，通过 .send() 手动触发事件
        // - Failure 类型为 Never，表示不会发出错误
        let passthroughSubject = PassthroughSubject<String, Never>()
        
        // 5. CurrentValueSubject：带当前值的 Publisher
        // - 初始化时提供初始值（"Initial"）
        // - 通过 .value 更新值，自动发出新值
        let currentValueSubject = CurrentValueSubject<String, Never>("Initial")
        // 更新值为 "Updated"，触发事件
        currentValueSubject.value = "Updated"
        
        // 合并五个 Publisher 的输出并订阅
        // - Publishers.Merge5 合并最多五个 Publisher，要求 Output 和 Failure 类型一致（这里是 String 和 Never）
        let cancellable = Publishers.Merge5(
            justPublisher.map { "Just: \($0)" }, // 将输出转换为 "Just: Hello"
            futurePublisher
                .catch { _ in Just("Fallback") } // 捕获错误，替换为 Just("Fallback")，确保 Failure 为 Never
                .map { "Future: \($0)" }, // 转换为 "Future: Async Result"
            timerPublisher.prefix(1).map { "Timer: \($0)" }, // 只取第一个值
            passthroughSubject.prefix(1).map { "Passthrough: \($0)" }, // 只取第一个值
            currentValueSubject.prefix(1).map { "CurrentValue: \($0)" } // 只取第一个值
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
        
        // 注意：订阅建立后发送 PassthroughSubject 的值
        // - 确保订阅者能接收到 "Manual Event"，因为 PassthroughSubject 只对订阅后的 .send() 生效
        passthroughSubject.send("Manual Event")
        
        // 返回 cancellable，供 ContentView 存储，管理订阅生命周期
        return cancellable
    }
}
