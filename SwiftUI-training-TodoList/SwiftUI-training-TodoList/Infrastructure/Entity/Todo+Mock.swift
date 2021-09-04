//
//  Todo+Mock.swift
//  SwiftUI-training-TodoList
//
//  Created by kawaharadai on 2021/08/28.
//

import Foundation

extension Todo {
    static func mock1() -> Todo {
        let todo = Todo()
        todo.id = 1
        todo.title = ""
        todo.content = ""
        todo.editDate = Date()
        return todo
    }
}
