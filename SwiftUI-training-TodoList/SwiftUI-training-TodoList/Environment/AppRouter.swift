//
//  AppRouter.swift
//  SwiftUI-training-TodoList
//
//  Created by kawaharadai on 2021/11/20.
//

import Foundation

struct AppRouter {
    static func makeTodoListView() -> TodoListView {
        let todoInfoDataStore = TodoInfoDataStoreImpl()
        let viewModel = TodoListViewModel(todoInfoDataStore: todoInfoDataStore)
        return TodoListView(viewModel: viewModel)
    }
}
