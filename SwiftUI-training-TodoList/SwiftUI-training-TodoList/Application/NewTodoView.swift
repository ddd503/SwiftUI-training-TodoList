//
//  NewTodoView.swift
//  SwiftUI-training-TodoList
//
//  Created by kawaharadai on 2021/10/16.
//

import SwiftUI

enum NewTodoViewState: Int, Hashable {
    case didLoad
}

struct NewTodoView: View {
    @ObservedObject var viewModel: NewTodoViewModel
    @FocusState var state: NewTodoViewState?

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    viewModel.onTapSaveButton()
                }) {
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
                .focused($state, equals: .didLoad)
        }
        .padding()
        .onAppear {
            // なぜここでTextEditorがfirstResponderにならない？
            state = .didLoad
        }
    }
}

struct TodoView_Previews: PreviewProvider {
    @State static var dummy = false

    static var previews: some View {
        NewTodoView(viewModel: NewTodoViewModel(showNewTodoView: TodoView_Previews.$dummy))
    }
}
