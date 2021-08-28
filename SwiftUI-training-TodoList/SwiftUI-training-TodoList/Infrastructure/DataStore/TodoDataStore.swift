//
//  TodoDataStore.swift
//  SwiftUI-training-TodoList
//
//  Created by kawaharadai on 2021/08/21.
//

import Combine

protocol TodoDataStore {
    func create(title: String, content: String?) -> AnyPublisher<[Todo], Never>
    func read() -> AnyPublisher<[Todo], Never>
    func update(todo: Todo) -> AnyPublisher<[Todo], Never>
    func delete(todo: Todo) -> AnyPublisher<[Todo], Never>
}

struct TodoDataStoreImpl: TodoDataStore {
    func create(title: String, content: String?) -> AnyPublisher<[Todo], Never> {
        // 仮で値を返す
        Just([Todo]()).eraseToAnyPublisher()
    }

    func read() -> AnyPublisher<[Todo], Never> {
        // 仮で値を返す
        Just([Todo]()).eraseToAnyPublisher()
    }

    func update(todo: Todo) -> AnyPublisher<[Todo], Never> {
        // 仮で値を返す
        Just([Todo]()).eraseToAnyPublisher()
    }

    func delete(todo: Todo) -> AnyPublisher<[Todo], Never> {
        // 仮で値を返す
        Just([Todo]()).eraseToAnyPublisher()
    }
}
