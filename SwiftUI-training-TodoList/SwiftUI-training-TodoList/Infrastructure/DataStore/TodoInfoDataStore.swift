//
//  TodoInfoDataStore.swift
//  SwiftUI-training-TodoList
//
//  Created by kawaharadai on 2021/08/21.
//

import Combine
import Foundation
import CoreData

protocol TodoInfoDataStore {
    func create(title: String, content: String?) -> AnyPublisher<TodoInfo, Error>
    func read() -> AnyPublisher<[TodoInfo], Error>
    func update(todoInfo: TodoInfo) -> AnyPublisher<TodoInfo, Error>
    func delete(todoInfo: TodoInfo) -> AnyPublisher<Void, Error>
}

enum TodoDataStoreError: Error {
    case notFound
}

final class TodoInfoDataStoreImpl: TodoInfoDataStore {
    private var coreDataEnvironment: CoreDataEnvironment

    init(coreDataEnvironment: CoreDataEnvironment) {
        self.coreDataEnvironment = coreDataEnvironment
    }

    func create(title: String, content: String?) -> AnyPublisher<TodoInfo, Error> {
        coreDataEnvironment.setInsertTodoInfo(title: title, content: content)
        return coreDataEnvironment.insertTodoAnyPublisher()
            .map { todo in
                TodoInfo(id: todo.uuid!,
                         title: todo.title,
                         content: todo.content,
                         editDate: todo.editDate)
            }
            .eraseToAnyPublisher()
    }

    func read() -> AnyPublisher<[TodoInfo], Error> {
        let fetchRequest = NSFetchRequest<Todo>(entityName: "Todo")
        let sortDescriptor = NSSortDescriptor(key: "editDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        coreDataEnvironment.setFetchRequest(fetchRequest)
        return coreDataEnvironment.fetchTodoPublisher()
            .map {
                $0.map { todo in
                    TodoInfo(id: todo.uuid!,
                             title: todo.title,
                             content: todo.content,
                             editDate: todo.editDate)
                }
            }
            .eraseToAnyPublisher()
    }

    func update(todoInfo: TodoInfo) -> AnyPublisher<TodoInfo, Error> {
        let fetchRequest = NSFetchRequest<Todo>(entityName: "Todo")
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", todoInfo.id)
        fetchRequest.fetchLimit = 1
        coreDataEnvironment.setFetchRequest(fetchRequest)
        return coreDataEnvironment.fetchTodoPublisher()
            .flatMap { [unowned self] fetchResult -> AnyPublisher<Void, Error> in
                self.firstTodoPublisher(todoList: fetchResult)
                    .flatMap { todo -> AnyPublisher<Void, Error> in
                        todo.title = todoInfo.title
                        todo.content = todoInfo.content
                        todo.editDate = Date()
                        return coreDataEnvironment.saveDataPublisher()
                    }.eraseToAnyPublisher()
            }
            .map {_ in
                todoInfo
            }
            .eraseToAnyPublisher()
    }

    func delete(todoInfo: TodoInfo) -> AnyPublisher<Void, Error> {
        let fetchRequest = NSFetchRequest<Todo>(entityName: "Todo")
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", todoInfo.id)
        fetchRequest.fetchLimit = 1
        coreDataEnvironment.setFetchRequest(fetchRequest)
        return coreDataEnvironment.fetchTodoPublisher()
            .flatMap { [unowned self] fetchResult -> AnyPublisher<Void, Error> in
                self.firstTodoPublisher(todoList: fetchResult)
                    .flatMap { todo -> AnyPublisher<Void, Error> in
                        todo.title = todoInfo.title
                        todo.content = todoInfo.content
                        todo.editDate = Date()
                        coreDataEnvironment.setDeleteTodo(todo)
                        return coreDataEnvironment.deleteTodoPublisher()
                            .flatMap { _ -> AnyPublisher<Void, Error> in
                                coreDataEnvironment.saveDataPublisher()
                            }.eraseToAnyPublisher()
                    }.eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    private func firstTodoPublisher(todoList: [Todo]) -> Future<Todo, Error> {
        Future<Todo, Error> { promise in
            guard let todo = todoList.first else {
                promise(.failure(TodoDataStoreError.notFound))
                return
            }
            promise(.success(todo))
        }
    }
}
