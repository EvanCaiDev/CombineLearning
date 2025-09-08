//
//  SwiftUIIntegrationExample.swift
//  CombineLearning
//
//  Created by caiwanhong on 2025/9/8.
//

import Foundation
import Combine
import SwiftUI


struct SwiftUIIntegrationExample {
    // 定义 ViewModel 类，遵循 ObservableObject 协议以支持 SwiftUI 数据绑定
    class ViewModel: ObservableObject {
        // @Published 属性包装器使 username、password 和 isLoginEnabled 成为 Publisher
        // - 每次值变化都会触发 Publisher 发出新值
        @Published var username = ""
        @Published var password = ""
        @Published var isLoginEnabled = false
        
        // 初始化 ViewModel，设置 Combine 管道以动态更新 isLoginEnabled
        init() {
            // 使用 Publishers.CombineLatest 组合 username 和 password 的最新值
            // - $username 和 $password 是 @Published 属性生成的 Publisher
            // - 每次任一值变化，发出最新的 (username, password) 元组
            Publishers.CombineLatest($username, $password)
                // map 将 (username, password) 转换为 Bool，表示登录按钮是否启用
                // - 用户名非空且密码长度 >= 6 时返回 true
                .map { username, password in
                    !username.isEmpty && password.count >= 6
                }
                // assign 将 map 的结果（Bool）绑定到 isLoginEnabled
                // - &$isLoginEnabled 是 Published<Bool>.Publisher 的可变引用
                .assign(to: &$isLoginEnabled)
        }
    }

    func run() -> AnyCancellable {

        print("=== SwiftUI 与 Combine 集成示例 ===")
        
        let vm = ViewModel()
        
        // 模拟用户输入，测试 Combine 管道
        // - 设置 username 和 password，触发 $username 和 $password 发出值
        vm.username = "user"
        vm.password = "123456"
        
        // 订阅 isLoginEnabled 的变化，打印其值
        // - $isLoginEnabled 是 @Published 属性生成的 Publisher
        // - sink 接收并打印每次 isLoginEnabled 的变化
        return vm.$isLoginEnabled
            .sink { value in
                print("Login Enabled: \(value)")
            }
    }
}
