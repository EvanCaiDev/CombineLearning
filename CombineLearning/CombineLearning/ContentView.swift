//
//  ContentView.swift
//  CombineLearning
//
//  Created by caiwanhong on 2025/9/8.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State private var cancellables = Set<AnyCancellable>()

    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Combine Knowledge Points")) {
                    //.store(in: &cancellables) 的作用就是 把订阅保存起来，保持有效，同时自动管理生命周期，防止订阅被提前释放或内存泄漏。
                    Button("1. Publisher") { PublisherExample().run().store(in: &cancellables) }
                    Button("2. Subscriber") { SubscriberExample().run().store(in: &cancellables) }
                    Button("3. Data Transformation") { DataTransformationExample().run().store(in: &cancellables) }
                    Button("4. Data Filtering") { DataFilteringExample().run().store(in: &cancellables) }
                    Button("5. Time Processing") { TimeProcessingExample().run().store(in: &cancellables) }
                    Button("6. Merging Streams") { MergingStreamsExample().run().store(in: &cancellables) }
                    Button("7. Sequence Operations") { SequenceOperationsExample().run().store(in: &cancellables) }
                    Button("8. Error Handling") { ErrorHandlingExample().run().store(in: &cancellables) }
                    Button("9. Memory Management") { MemoryManagementExample().run().store(in: &cancellables) }
                    Button("10. Scheduling") { SchedulingExample().run().store(in: &cancellables) }
                    Button("11. SwiftUI Integration") { SwiftUIIntegrationExample().run().store(in: &cancellables) }
                    Button("12. Debugging Tools") { DebuggingToolsExample().run().store(in: &cancellables) }
                    Button("13. Network Request") { NetworkRequestExample().run().store(in: &cancellables) }
                    Button("14. Debounce Search") { DebounceSearchExample().run().store(in: &cancellables) }
                }
            }
            .navigationTitle("Combine Learning")
        }
    }
}


#Preview {
    ContentView()
}
