//
//  NewTodoViewModel.swift
//  SwiftUI-training-TodoList
//
//  Created by kawaharadai on 2021/10/16.
//

import Foundation
import Combine
import SwiftUI

final class NewTodoViewModel: ObservableObject {
    @Published var todoText: String = ""
    private(set) var showNewTodoView: Binding<Bool>
    private let todoInfoDataStore: TodoInfoDataStore
    private var cancellables = Set<AnyCancellable>()

    init(todoInfoDataStore: TodoInfoDataStore = TodoInfoDataStoreImpl(),
         showNewTodoView: Binding<Bool>) {
        self.todoInfoDataStore = todoInfoDataStore
        self.showNewTodoView = showNewTodoView
    }

    func onTapCloseButton() {
        showNewTodoView.wrappedValue = false
    }

    func onTapSaveButton() {
        todoInfoDataStore.create(title: "", content: todoText)
            .sink { [unowned self] completion in
                switch completion {
                case .failure(let error):
                    print("Todo作成失敗:\(error)")
                    // 失敗アラート出しても良い
                case .finished:
                    print("作成成功")
                    self.showNewTodoView.wrappedValue = false
                }
            } receiveValue: { todoInfo in
                print("作成されたTodo:\(todoInfo)")
            }
            .store(in: &cancellables)
    }
}
