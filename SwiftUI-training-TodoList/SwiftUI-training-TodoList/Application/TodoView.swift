//
//  TodoView.swift
//  SwiftUI-training-TodoList
//
//  Created by kawaharadai on 2021/10/16.
//

import SwiftUI

struct TodoView: View {
    @ObservedObject var viewModel: TodoViewModel

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
        TodoView(viewModel: TodoViewModel())
    }
}
