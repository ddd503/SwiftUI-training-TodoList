//
//  TodoListViewModel.swift
//  SwiftUI-training-TodoList
//
//  Created by kawaharadai on 2021/09/30.
//

import Foundation
import Combine

final class TodoListViewModel: ObservableObject {
    private let todoInfoDataStore: TodoInfoDataStore
    private var cancellables = Set<AnyCancellable>()
    @Published private(set) var todoList: [TodoInfo] = TodoInfo.mockList

    init(todoInfoDataStore: TodoInfoDataStore = TodoInfoDataStoreImpl()) {
        self.todoInfoDataStore = todoInfoDataStore
    }
}
