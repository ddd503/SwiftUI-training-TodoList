//
//  ContentView.swift
//  SwiftUI-training-TodoList
//
//  Created by kawaharadai on 2021/08/06.
//

import SwiftUI
import CoreData
import Combine

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Todo.editDate, ascending: true)], animation: .default)
    private var todoList: FetchedResults<Todo>
    private let viewModel: TodoListViewModel

    init(viewModel: TodoListViewModel = TodoListViewModel()) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        NavigationView {
            Group {
                List {
                    ForEach(todoList) { todo in
                        Text("最終更新： \(todo.editDate!, formatter: itemFormatter)")
                    }
                    .onDelete(perform: deleteItems)
                }

            }
            .navigationTitle("TodoList")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing){
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing){
                    Button(action: addTodo) {
                        Image(systemName: "plus.circle")
                    }
                }
            }
        }
    }

    private func addTodo() {
        withAnimation {
            viewModel.addTodo()
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { todoList[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, CoreDataManager.preview.container.viewContext)
    }
}
