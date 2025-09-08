//
//  SubscriberExample.swift
//  CombineLearning
//
//  Created by caiwanhong on 2025/9/8.
//

import Foundation
import Combine

struct SubscriberExample {
    // 定义 ViewModel 类，使用 @Published 属性包装器支持 Combine 绑定
    class ViewModel {
        // @Published 使 text 属性成为 Publisher，发出值变化
        @Published var text = ""
    }
    
    // run 方法运行示例，返回 AnyCancellable 用于管理订阅生命周期
    func run() -> AnyCancellable {
        // 打印标题，方便在控制台区分此示例的输出
        print("=== 订阅者示例 ===")
        
        // 创建 Just Publisher，发出单一值 "Hello" 后完成
        // - Output 类型为 String，Failure 类型为 Never（不会失败）
        let publisher = Just("Hello")
        
        // 创建 ViewModel 实例，用于测试 assign 订阅
        let vm = ViewModel()
        
        // 1. sink 订阅：处理值和完成事件
        // - sink 接收 publisher 的值和完成事件，打印到控制台
        // - receiveCompletion：处理完成事件（.finished 或 .failure）
        // - receiveValue：处理发出的值
        let sinkCancellable = publisher.sink(
            receiveCompletion: { completion in
                print("完成: \(completion)")
            },
            receiveValue: { value in
                print("Sink 值: \(value)")
            }
        )
        
        // 2. assign 订阅：将值绑定到对象的属性
        // - assign 将 publisher 的值直接赋值给 vm.text（通过 KeyPath）
        // - 要求目标对象为 class 类型，属性必须用 @Published 包装
        let assignCancellable = publisher.assign(to: \.text, on: vm)
        
        // 验证 assign 订阅效果，立即打印 vm.text
        // - 确认值 "Hello" 已赋值给 vm.text
        print("ViewModel text: \(vm.text)")
        
        // 返回 AnyCancellable，封装取消逻辑
        // - 取消 sink 和 assign 订阅以释放资源
        // - 在 ContentView 销毁时自动执行，防止内存泄漏
        return AnyCancellable {
            sinkCancellable.cancel()
            assignCancellable.cancel()
        }
    }
}
