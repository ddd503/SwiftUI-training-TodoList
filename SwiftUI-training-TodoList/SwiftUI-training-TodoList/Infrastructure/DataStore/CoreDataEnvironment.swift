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
    func setInsertTodoInfo(title: String, content: String?)
    func setFetchRequest(_ fetchRequest: NSFetchRequest<Todo>)
    func setDeleteTodo(_ todo: Todo)
    func saveDataPublisher() -> AnyPublisher<Void, Error>
    func insertTodoAnyPublisher() -> AnyPublisher<Todo, Error>
    func fetchTodoPublisher() -> AnyPublisher<[Todo], Error>
    func deleteTodoPublisher() -> AnyPublisher<Void, Never>
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

    func setInsertTodoInfo(title: String, content: String?) {
        insertTodoPublisher.title = title
        insertTodoPublisher.content = content
    }

    func setFetchRequest(_ fetchRequest: NSFetchRequest<Todo>) {
        fetchPublisher.request = fetchRequest
    }

    func setDeleteTodo(_ todo: Todo) {
        deletePublisher.dataModel = todo
    }

    func saveDataPublisher() -> AnyPublisher<Void, Error> {
        savePublisher.eraseToAnyPublisher()
    }
    
    func insertTodoAnyPublisher() -> AnyPublisher<Todo, Error> {
        insertTodoPublisher.eraseToAnyPublisher()
    }

    func fetchTodoPublisher() -> AnyPublisher<[Todo], Error> {
        fetchPublisher.eraseToAnyPublisher()
    }

    func deleteTodoPublisher() -> AnyPublisher<Void, Never> {
        deletePublisher.eraseToAnyPublisher()
    }
}
