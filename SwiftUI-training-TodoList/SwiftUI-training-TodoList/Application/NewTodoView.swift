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
        VStack {
            HStack {
                Button(action: {}) {
                    Text("保存")
                }
                Spacer()
                Button(action: {
                    viewModel.onTapCloseButton()
                }) {
                    Text("閉じる")
                }
            }
            TextEditor(text: $viewModel.todoText)
        }
        .padding()
        .onDisappear {
            viewModel.onDisappear()
        }
    }
}

struct TodoView_Previews: PreviewProvider {
    @State static var dummy = false

    static var previews: some View {
        NewTodoView(viewModel: NewTodoViewModel(showNewTodoView: TodoView_Previews.$dummy))
    }
}
