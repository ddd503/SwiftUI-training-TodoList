//
//  TodoListViewModel.swift
//  SwiftUI-training-TodoList
//
//  Created by kawaharadai on 2021/09/30.
//

import Foundation
import Combine
import CoreData

final class TodoListViewModel: ObservableObject {
    private let todoDataStore: TodoDataStore
    private var cancellables = Set<AnyCancellable>()
    @Published private(set) var todoList: [TodoInfo] = TodoInfo.mockList

    init(todoDataStore: TodoDataStore = TodoDataStoreImpl()) {
        self.todoDataStore = todoDataStore
    }
}
