//
//  AppRouter.swift
//  SwiftUI-training-TodoList
//
//  Created by kawaharadai on 2021/11/20.
//

import Foundation
import SwiftUI
import CoreData

struct AppRouter {
    static func makeTodoListView() -> TodoListView {
        let todoInfoDataStore = TodoInfoDataStoreImpl(coreDataEnvironment: makeCoreDataEnvironment())
        let viewModel = TodoListViewModel(todoInfoDataStore: todoInfoDataStore)
        return TodoListView(viewModel: viewModel)
    }

    static func makeNewTodoView(showNewTodoView: Binding<Bool>) -> NewTodoView {
        let todoInfoDataStore = TodoInfoDataStoreImpl(coreDataEnvironment: makeCoreDataEnvironment())
        let viewModel = NewTodoViewModel(todoInfoDataStore: todoInfoDataStore, showNewTodoView: showNewTodoView)
        return NewTodoView(viewModel: viewModel)
    }

    static func makeCoreDataEnvironment() -> CoreDataEnvironment {
        let context = CoreDataManager.shared.container.viewContext
        let insertPublisher = CoreDataInsertPublisher(context: context,
                                                      uuid: UUID().uuidString,
                                                      editDate: Date())
        let fetchRequest = NSFetchRequest<Todo>(entityName: "Todo")
        let sortDescriptor = NSSortDescriptor(key: "editDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchPublisher = CoreDataFetchPublisher<Todo>(context: context,
                                                          request: fetchRequest)
        return CoreDataEnvironmentImpl(insertPublisher: insertPublisher,
                                       fetchPublisher: fetchPublisher)
    }
}
