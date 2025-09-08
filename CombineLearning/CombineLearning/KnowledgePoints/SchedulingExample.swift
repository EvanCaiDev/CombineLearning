//
//  SchedulingExample.swift
//  CombineLearning
//
//  Created by caiwanhong on 2025/9/8.
//

import Foundation
import Combine

struct SchedulingExample {

    func run() -> AnyCancellable {

        print("=== 调度示例 ===")
        
        // 创建 Just Publisher，发出单一值 "Hello" 后完成
        // - Output 类型为 String，Failure 类型为 Never（不会失败）
        let publisher = Just("Hello")
        
        // 使用调度操作符控制线程
        // - subscribe(on:) 指定订阅操作在全局队列（后台线程）执行
        // - receive(on:) 指定值和完成事件的接收在主队列（主线程）执行
        // - sink 接收并打印值，显示当前线程信息
        return publisher
            .subscribe(on: DispatchQueue.global()) // 在后台线程处理订阅
            .receive(on: DispatchQueue.main) // 在主线程接收值
            .sink { value in
                print("Received: \(value) on thread: \(Thread.current)")
            }
    }
}
