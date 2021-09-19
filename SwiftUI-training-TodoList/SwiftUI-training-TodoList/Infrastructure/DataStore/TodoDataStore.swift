//
//  TodoDataStore.swift
//  SwiftUI-training-TodoList
//
//  Created by kawaharadai on 2021/08/21.
//

import Combine
import Foundation
import CoreData

protocol TodoDataStore {
    func create(title: String, content: String?) -> AnyPublisher<Void, Error>
    func read() -> AnyPublisher<[Todo], Error>
    func update(todo: Todo) -> AnyPublisher<[Todo], Never>
    func delete(todo: Todo) -> AnyPublisher<[Todo], Never>
}

struct TodoDataStoreImpl: TodoDataStore {
    func create(title: String, content: String?) -> AnyPublisher<Void, Error> {
        let context = CoreDataManager.shared.container.viewContext
        let newTodo = Todo(context: context)
        // TODO: 最大値に1足した値がidになる
        //        newTodo.id = ??
        newTodo.title = title
        newTodo.content = content
        newTodo.editDate = Date()
        return Future<Void, Error> { promise in
            do {
                try context.save()
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }

    func read() -> AnyPublisher<[Todo], Error> {
        let context = CoreDataManager.shared.container.viewContext
        let fetchRequest = NSFetchRequest<Todo>(entityName: "Todo")
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return Future<[Todo], Error> { promise in
            do {
                let todoList = try context.fetch(fetchRequest)
                promise(.success(todoList))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
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
