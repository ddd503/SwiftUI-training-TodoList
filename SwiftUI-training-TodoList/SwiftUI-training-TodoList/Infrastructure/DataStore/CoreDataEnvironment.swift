//
//  CoreDataEnvironment.swift
//  SwiftUI-training-TodoList
//
//  Created by kawaharadai on 2021/11/28.
//

import Foundation
import Combine
import CoreData

protocol CoreDataEnvironment {
    func saveDataPublisher() -> AnyPublisher<Void, Error>
    func insertTodoAnyPublisher(title: String, content: String?) -> AnyPublisher<Todo, Error>
    func fetchTodoPublisher(fetchRequest: NSFetchRequest<Todo>) -> AnyPublisher<[Todo], Error>
    func deleteTodoPublisher(todo: Todo) -> AnyPublisher<Void, Never>
}

class CoreDataEnvironmentImpl: CoreDataEnvironment {
    let savePublisher: CoreDataSavePublisher
    var insertTodoPublisher: CoreDataInsertTodoPublisher
    var fetchPublisher: CoreDataFetchPublisher<Todo>
    var deletePublisher: CoreDataDeletePublisher<Todo>

    init(savePublisher: CoreDataSavePublisher,
         insertTodoPublisher: CoreDataInsertTodoPublisher,
         fetchPublisher: CoreDataFetchPublisher<Todo>,
         deletePublisher: CoreDataDeletePublisher<Todo>) {
        self.savePublisher = savePublisher
        self.insertTodoPublisher = insertTodoPublisher
        self.fetchPublisher = fetchPublisher
        self.deletePublisher = deletePublisher
    }

    func saveDataPublisher() -> AnyPublisher<Void, Error> {
        savePublisher.eraseToAnyPublisher()
    }
    
    func insertTodoAnyPublisher(title: String, content: String?) -> AnyPublisher<Todo, Error> {
        insertTodoPublisher.title = title
        insertTodoPublisher.content = content
        return insertTodoPublisher.eraseToAnyPublisher()
    }

    func fetchTodoPublisher(fetchRequest: NSFetchRequest<Todo>) -> AnyPublisher<[Todo], Error> {
        fetchPublisher.request = fetchRequest
        return fetchPublisher.eraseToAnyPublisher()
    }

    func deleteTodoPublisher(todo: Todo) -> AnyPublisher<Void, Never> {
        deletePublisher.dataModel = todo
        return deletePublisher.eraseToAnyPublisher()
    }
}
