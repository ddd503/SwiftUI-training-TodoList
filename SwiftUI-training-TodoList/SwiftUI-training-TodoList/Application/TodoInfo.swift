//
//  TodoInfo.swift
//  SwiftUI-training-TodoList
//
//  Created by kawaharadai on 2021/10/07.
//

import Foundation

struct TodoInfo: Identifiable {
    let id: String
    let title: String?
    let content: String?
    let editDate: Date?

    static let mock = {
        TodoInfo(id: UUID().uuidString,
                 title: "タイトル",
                 content: "本文",
                 editDate: Date())
    }()

    static let mockList = {
        [TodoInfo(id: UUID().uuidString,
                  title: "タイトル1",
                  content: "本文1",
                  editDate: Date()),
         TodoInfo(id: UUID().uuidString,
                  title: "タイトル2",
                  content: "本文2",
                  editDate: Date()),
         TodoInfo(id: UUID().uuidString,
                  title: "タイトル3",
                  content: "本文3",
                  editDate: Date())]
    }()
}
