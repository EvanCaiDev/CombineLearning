//
//  TimeProcessingExample.swift
//  CombineLearning
//
//  Created by caiwanhong on 2025/9/8.
//

import Foundation
import Combine
import SwiftUI

struct TimeProcessingExample {
    // 定义 ViewModel 类，遵循 ObservableObject 协议以支持 SwiftUI 数据绑定
    class ViewModel: ObservableObject {
        // @Published 属性包装器使 input 成为 Publisher，发出值变化
        @Published var input = ""
    }
    
    func run() -> AnyCancellable {
        print("=== Time Processing Example ===")
        
        let vm = ViewModel()
        
        // 1. debounce 操作符：延迟发出值，直到指定时间（500ms）内无新值
        // - vm.$input 是 @Published 属性生成的 Publisher，发出 input 的每次变化
        // - debounce 等待 500ms 后发出最新值（如果期间无新值）
        // - scheduler: DispatchQueue.main 确保在主线程处理，适合 UI 更新
        let debouncePublisher = vm.$input
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
        
        // 2. throttle 操作符：按固定时间间隔（1秒）发出最新值
        // - throttle 每 1 秒发出 input 的最新值（latest: true 表示选择最新值）
        // - scheduler: DispatchQueue.main 确保在主线程处理
        let throttlePublisher = vm.$input
            .throttle(for: .seconds(1), scheduler: DispatchQueue.main, latest: true)
        
        // 模拟用户输入，触发 input 值变化
        // - 设置 input 为 "Test"，测试 debounce 和 throttle 的行为
        vm.input = "Test"
        
        // 使用 Publishers.Merge 合并两个 Publisher 的输出
        // - Merge 要求 Output 类型一致（通过 .map 转换为 String）
        // - Failure 类型为 Never（@Published 不发出错误）
        // - 为每个 Publisher 的输出添加标签，便于区分
        return Publishers.Merge(
            debouncePublisher.map { "Debounce: \($0)" }, // 将 input 值转换为带 "Debounce" 标签的字符串
            throttlePublisher.map { "Throttle: \($0)" } // 将 input 值转换为带 "Throttle" 标签的字符串
        )
        // 使用 sink 订阅合并后的 Publisher
        // - receiveCompletion：处理完成事件（.finished 或 .failure）
        // - receiveValue：处理每个发出的值并打印到控制台
        .sink(
            receiveCompletion: { print("Completion: \($0)") },
            receiveValue: { print($0) }
        )
    }
}
