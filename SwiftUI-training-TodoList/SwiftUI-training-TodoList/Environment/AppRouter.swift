//
//  AppRouter.swift
//  SwiftUI-training-TodoList
//
//  Created by kawaharadai on 2021/11/20.
//

import Foundation

struct AppRouter {
    static func makeTodoListView() -> TodoListView {
        let insertPublisher = CoreDataInsertPublisher(context: CoreDataManager.shared.container.viewContext,
                                                      uuid: UUID().uuidString,
                                                      editDate: Date())
        let todoInfoDataStore = TodoInfoDataStoreImpl(insertPublisher: insertPublisher)
        let viewModel = TodoListViewModel(todoInfoDataStore: todoInfoDataStore)
        return TodoListView(viewModel: viewModel)
    }
}
