//
//  CoreDataEnvironment.swift
//  SwiftUI-training-TodoList
//
//  Created by kawaharadai on 2021/11/28.
//

import Foundation

protocol CoreDataEnvironment {
    var insertPublisher: CoreDataInsertPublisher { get set }
    var fetchPublisher: CoreDataFetchPublisher<Todo> { get }
}

struct CoreDataEnvironmentImpl: CoreDataEnvironment {
    var insertPublisher: CoreDataInsertPublisher
    let fetchPublisher: CoreDataFetchPublisher<Todo>

    init(insertPublisher: CoreDataInsertPublisher, fetchPublisher: CoreDataFetchPublisher<Todo>) {
        self.insertPublisher = insertPublisher
        self.fetchPublisher = fetchPublisher
    }
}
