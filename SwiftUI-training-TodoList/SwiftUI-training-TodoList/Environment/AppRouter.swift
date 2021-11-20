//
//  AppRouter.swift
//  SwiftUI-training-TodoList
//
//  Created by kawaharadai on 2021/11/20.
//

import Foundation
import SwiftUI

struct AppRouter {
    static func makeTodoListView() -> TodoListView {
        // CoreDataInsertPublisher使ってないからoptionalにしたい
        let insertPublisher = CoreDataInsertPublisher(context: CoreDataManager.shared.container.viewContext,
                                                      uuid: UUID().uuidString,
                                                      editDate: Date())
        let todoInfoDataStore = TodoInfoDataStoreImpl(insertPublisher: insertPublisher)
        let viewModel = TodoListViewModel(todoInfoDataStore: todoInfoDataStore)
        return TodoListView(viewModel: viewModel)
    }

    static func makeNewTodoView(showNewTodoView: Binding<Bool>) -> NewTodoView {
        let insertPublisher = CoreDataInsertPublisher(context: CoreDataManager.shared.container.viewContext,
                                                      uuid: UUID().uuidString,
                                                      editDate: Date())
        let todoInfoDataStore = TodoInfoDataStoreImpl(insertPublisher: insertPublisher)
        let viewModel = NewTodoViewModel(todoInfoDataStore: todoInfoDataStore, showNewTodoView: showNewTodoView)
        return NewTodoView(viewModel: viewModel)
    }
}
