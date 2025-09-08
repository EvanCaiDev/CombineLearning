//
//  NetworkRequestExample.swift
//  CombineLearning
//
//  Created by caiwanhong on 2025/9/8.
//

import Foundation
import Combine

struct NetworkRequestExample {

    func run() -> AnyCancellable {

        print("=== 网络请求示例 ===")
        
        // 定义一个函数，模拟网络请求，返回 AnyPublisher
        // - 返回类型为 AnyPublisher<String, Error>，支持发出字符串或错误
        func fetchData() -> AnyPublisher<String, Error> {
            // 使用 Just 模拟网络请求，发出单一值 "Simulated Data"
            // - setFailureType(to: Error.self) 将 Failure 类型设置为 Error
            // - eraseToAnyPublisher() 将具体 Publisher 类型擦除为 AnyPublisher
            Just("Simulated Data")
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
        // 调用 fetchData() 获取 Publisher 并订阅
        // - sink 接收值和完成事件，打印数据或错误
        return fetchData()
            .sink(
                receiveCompletion: { completion in
                    // 处理完成事件（成功或失败）
                    print("完成: \(completion)")
                },
                receiveValue: { value in
                    // 打印接收到的数据
                    print("数据: \(value)")
                }
            )
    }
}
