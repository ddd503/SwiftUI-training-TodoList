//
//  SwiftUI_training_TodoListApp.swift
//  SwiftUI-training-TodoList
//
//  Created by kawaharadai on 2021/08/06.
//

import SwiftUI

@main
struct SwiftUI_training_TodoListApp: App {
    let coreDataManager = CoreDataManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, coreDataManager.container.viewContext)
        }
    }
}
