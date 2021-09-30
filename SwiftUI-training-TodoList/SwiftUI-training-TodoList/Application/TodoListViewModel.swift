//
//  TodoListViewModel.swift
//  SwiftUI-training-TodoList
//
//  Created by kawaharadai on 2021/09/30.
//

import Foundation
import Combine

final class TodoListViewModel {
    private let todoDataStore: TodoDataStore
    private var cancellables = Set<AnyCancellable>()

    init(todoDataStore: TodoDataStore = TodoDataStoreImpl()) {
        self.todoDataStore = todoDataStore
    }

    func addTodo() {
        todoDataStore.create(title: "タイトル", content: "本文")
            .sink { completion in

            } receiveValue: { _ in
                print("正常に終了")
            }
            .store(in: &cancellables)
    }
}
