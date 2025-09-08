//
//  MemoryManagementExample.swift
//  CombineLearning
//
//  Created by caiwanhong on 2025/9/8.
//

import Foundation
import Combine

struct MemoryManagementExample {

    func run() -> AnyCancellable {

        print("=== 内存管理示例 ===")
        
        // 创建 Just Publisher，发出单一值 "Hello" 后完成
        // - Output 类型为 String，Failure 类型为 Never（不会失败）
        let publisher = Just("Hello")
        
        // 使用 sink 创建订阅，处理发出的值
        // - sink 接收 publisher 的值并打印
        // - 返回 AnyCancellable 对象，用于管理订阅
        let cancellable = publisher
            .sink { print("Value: \($0)") }
        
        // 返回 AnyCancellable，封装取消逻辑
        // - 当订阅被取消时（例如 ContentView 销毁），调用 cancellable.cancel()
        // - 打印取消信息，验证取消行为
        return AnyCancellable {
            cancellable.cancel()
            print("Subscription cancelled")
        }
    }
}
