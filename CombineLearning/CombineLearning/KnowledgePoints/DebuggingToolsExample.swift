//
//  DebuggingToolsExample.swift
//  CombineLearning
//
//  Created by caiwanhong on 2025/9/8.
//

import Foundation
import Combine

struct DebuggingToolsExample {

    func run() -> AnyCancellable {
        
        print("=== 调试工具示例 ===")
        
        // 创建 Just Publisher，发出单一值 "Hello" 后完成
        // - Output 类型为 String，Failure 类型为 Never（不会失败）
        let publisher = Just("Hello")
        
        // 使用调试操作符跟踪 Publisher 的事件流
        // - print("Debug")：输出所有事件（订阅、值、完成等）的详细日志
        // - handleEvents(receiveOutput:)：在接收值时执行自定义操作，打印值
        // - sink：接收并打印最终值
        return publisher
            .print("Debug") // 输出事件流日志，带有 "Debug" 前缀
            .handleEvents(receiveOutput: { value in
                print("HandleEvents: \(value)") // 在接收值时打印
            })
            .sink { value in
                print("Value: \(value)") // 打印最终接收的值
            }
    }
}
