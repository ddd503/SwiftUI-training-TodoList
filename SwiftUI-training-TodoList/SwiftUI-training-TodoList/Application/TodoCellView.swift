//
//  TodoCellView.swift
//  SwiftUI-training-TodoList
//
//  Created by kawaharadai on 2021/10/04.
//

import SwiftUI

struct TodoInfo {
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
}

struct TodoCell: View {
    let todo: TodoInfo

    var body: some View {
        VStack(alignment: .leading) {
            Text(todo.title!)
            Spacer()
            HStack {
                Text("\(todo.editDate!, formatter: itemFormatter)")
                Text(todo.content!)
                Spacer()
            }
        }
    }

    private let itemFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeZone = TimeZone(identifier:  "Asia/Tokyo")
        dateFormatter.dateFormat = "yyyy/M/d"
        return dateFormatter
    }()
}

struct TodoCell_Previews: PreviewProvider {
    static var previews: some View {
        TodoCell(todo: TodoInfo.mock)
            .previewLayout(.fixed(width: 300, height: 50))
    }
}
