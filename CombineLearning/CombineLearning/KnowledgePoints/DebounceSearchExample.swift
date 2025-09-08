//
//  DebounceSearchExample.swift
//  CombineLearning
//
//  Created by caiwanhong on 2025/9/8.
//

import Foundation
import Combine
import SwiftUI

struct DebounceSearchExample {
    // 定义 ViewModel 类，遵循 ObservableObject 协议以支持 SwiftUI 数据绑定
    class ViewModel: ObservableObject {
        // @Published 属性包装器使 searchText 和 results 成为 Publisher
        // - searchText：存储用户输入的搜索文本
        // - results：存储搜索结果
        @Published var searchText = ""
        @Published var results: [String] = []
        
        // 初始化 ViewModel，设置 Combine 管道处理搜索逻辑
        init() {
            // 从 $searchText 开始，构建搜索处理管道
            $searchText
                // debounce：延迟 500ms 发出值，直到无新输入
                // - 避免频繁处理快速输入，优化性能
                // - scheduler: DispatchQueue.main 确保在主线程处理，适合 UI 更新
                .debounce(for: .milliseconds(500), scheduler: DispatchQueue.main)
                // removeDuplicates：移除连续重复的搜索文本
                // - 避免对相同查询重复处理
                .removeDuplicates()
                // flatMap：将搜索文本转换为新的 Publisher，模拟搜索结果
                // - 将每个查询转换为 Just Publisher，发出 ["Result for \(query)"]
                // - setFailureType(to: Error.self) 支持错误处理
                .flatMap { query in
                    Just(["Result for \(query)"]).setFailureType(to: Error.self)
                }
                // replaceError：将任何错误替换为空数组 []
                // - 确保管道继续运行，防止错误中断
                .replaceError(with: [])
                // assign：将结果绑定到 @Published var results
                // - 更新 results，触发 UI 刷新
                .assign(to: &$results)
        }
    }
    
    func run() -> AnyCancellable {

        print("=== 防抖搜索示例 ===")
        
        let vm = ViewModel()
        
        // 模拟用户输入，测试搜索逻辑
        // - 设置 searchText 为 "Test"，触发管道处理
        vm.searchText = "Test"
        
        // 订阅 results 的变化，打印每次结果更新
        // - $results 是 @Published 属性生成的 Publisher
        // - sink 接收并打印每次 results 的变化
        return vm.$results
            .sink { value in
                print("结果: \(value)")
            }
    }
}
