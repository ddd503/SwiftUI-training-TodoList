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
    @Published private(set) var todoList: [TodoInfo] = []

    init(todoInfoDataStore: TodoInfoDataStore = TodoInfoDataStoreImpl()) {
        self.todoInfoDataStore = todoInfoDataStore
    }

    func onAppear() {
        todoInfoDataStore.read()
            .replaceError(with: [])
            .subscribe(on: DispatchQueue.global())
            .receive(on: DispatchQueue.main)
            .assign(to: \.todoList, on: self)
            .store(in: &cancellables)
    }

    func onTapAdd() {
        // TextViewの画面に遷移
    }

    func onDelete(atOffsets indexSet: IndexSet) {
        indexSet.lazy
            .map { self.todoList[$0] }
            .forEach { todoInfo in
                todoInfoDataStore.delete(todoInfo: todoInfo)
                    .subscribe(on: DispatchQueue.global())
                    .receive(on: DispatchQueue.main)
                    .sink(receiveCompletion: {_ in }, receiveValue: { [unowned self] _ in
                        self.todoList.remove(atOffsets: indexSet)
                    })
                    .store(in: &cancellables)
            }
    }
}
