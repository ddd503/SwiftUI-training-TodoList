//
//  TodoListView.swift
//  SwiftUI-training-TodoList
//
//  Created by kawaharadai on 2021/10/04.
//

import SwiftUI

struct TodoListView: View {
    @ObservedObject var viewModel: TodoListViewModel

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.todoList) { todo in
                    TodoCell(todo: todo)
                }
                .onDelete { indexSet in
                    viewModel.onDelete(atOffsets: indexSet)
                }
            }
            .navigationTitle("TODO")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    EditButton()
                    Button(action: {}) {
                        Image(systemName: "plus.app.fill")
                    }
                    .frame(width: 50,
                           height: 50,
                           alignment: .center)
                }
            }
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView(viewModel: TodoListViewModel())
    }
}
