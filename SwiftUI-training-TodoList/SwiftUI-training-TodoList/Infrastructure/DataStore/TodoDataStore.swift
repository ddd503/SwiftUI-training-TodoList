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
    func update(todo: Todo) -> AnyPublisher<[Todo], Error>
    func delete(todo: Todo) -> AnyPublisher<[Todo], Never>
}

struct TodoDataStoreImpl: TodoDataStore {
    func create(title: String, content: String?) -> AnyPublisher<Void, Error> {
        let context = CoreDataManager.shared.container.viewContext
        return createNewId(context: context)
            .flatMap { newId -> AnyPublisher<Void, Error> in
                let newTodo = Todo(context: context)
                newTodo.id = newId
                newTodo.title = title
                newTodo.content = content
                newTodo.editDate = Date()
                return save(context: context)
            }
            .eraseToAnyPublisher()
    }

    func read() -> AnyPublisher<[Todo], Error> {
        let context = CoreDataManager.shared.container.viewContext
        let fetchRequest = NSFetchRequest<Todo>(entityName: "Todo")
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return Deferred {
            Future<[Todo], Error> { promise in
                do {
                    let todoList = try context.fetch(fetchRequest)
                    promise(.success(todoList))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    func update(todo: Todo) -> AnyPublisher<[Todo], Error> {
        let context = CoreDataManager.shared.container.viewContext
        return find(id: todo.id, context: context)
            .flatMap { foundTodo -> AnyPublisher<Void, Error> in
                foundTodo?.title = todo.title
                foundTodo?.content = todo.content
                foundTodo?.editDate = Date()
                return save(context: context)
            }
            .flatMap {_ -> AnyPublisher<[Todo], Error> in
                read()
            }
            .eraseToAnyPublisher()
    }

    func delete(todo: Todo) -> AnyPublisher<[Todo], Never> {
        // 仮で値を返す
        Just([Todo]()).eraseToAnyPublisher()
    }

    private func find(id: Int64, context: NSManagedObjectContext) -> AnyPublisher<Todo?, Error> {
        let fetchRequest = NSFetchRequest<Todo>(entityName: "Todo")
        let predicate = NSPredicate(format: "id == %@", id)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return Deferred {
            Future<Todo?, Error> { promise in
                do {
                    let fetchResult = try context.fetch(fetchRequest)
                    // 検索結果なし
                    guard !fetchResult.isEmpty else {
                        promise(.success(nil))
                        return
                    }
                    // idが重複している
                    guard fetchResult.count == 1 else {
                        promise(.success(nil))
                        return
                    }

                    promise(.success(fetchResult.first))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    private func save(context: NSManagedObjectContext) -> AnyPublisher<Void, Error> {
        Deferred {
            Future<Void, Error> { promise in
                do {
                    try context.save()
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    private func createNewId(context: NSManagedObjectContext) -> AnyPublisher<Int64, Error> {
        let fetchRequest = NSFetchRequest<Todo>(entityName: "Todo")
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return Deferred {
            Future<Int64, Error> { promise in
                do {
                    let todoList = try context.fetch(fetchRequest)
                    promise(.success(Int64(todoList.count + 1)))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
