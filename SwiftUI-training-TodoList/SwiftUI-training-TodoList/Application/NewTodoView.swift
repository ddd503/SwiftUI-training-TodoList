//
//  NewTodoView.swift
//  SwiftUI-training-TodoList
//
//  Created by kawaharadai on 2021/10/16.
//

import SwiftUI

struct NewTodoView: View {
    @ObservedObject var viewModel: NewTodoViewModel

    var body: some View {
        TextEditor(text: $viewModel.todoText)
            .padding()
            .onDisappear {
                viewModel.onDisappear()
            }
    }
}

struct TodoView_Previews: PreviewProvider {
    static var previews: some View {
        NewTodoView(viewModel: NewTodoViewModel())
    }
}
