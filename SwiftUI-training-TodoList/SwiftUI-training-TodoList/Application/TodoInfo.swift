//
//  TodoInfo.swift
//  SwiftUI-training-TodoList
//
//  Created by kawaharadai on 2021/10/07.
//

import Foundation

struct TodoInfo: Identifiable {
    let id: Int64
    let title: String?
    let content: String?
    let editDate: Date?

    static let mock = {
        TodoInfo(id: 1,
                 title: "タイトル",
                 content: "本文",
                 editDate: Date())
    }()

    static let mockList = {
        [TodoInfo(id: 1,
                  title: "タイトル1",
                  content: "本文1",
                  editDate: Date()),
         TodoInfo(id: 2,
                  title: "タイトル2",
                  content: "本文2",
                  editDate: Date()),
         TodoInfo(id: 3,
                  title: "タイトル3",
                  content: "本文3",
                  editDate: Date())]
    }()
}
