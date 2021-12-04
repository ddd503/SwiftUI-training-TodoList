//
//  CoreDataEnvironment.swift
//  SwiftUI-training-TodoList
//
//  Created by kawaharadai on 2021/11/28.
//

import Foundation
import CoreData

protocol CoreDataEnvironment {
    var savePublisher: CoreDataSavePublisher { get }
    var insertPublisher: CoreDataInsertPublisher { get set }
    var fetchPublisher: CoreDataFetchPublisher<Todo> { get set }
    var deletePublisher: CoreDataDeletePublisher<Todo> { get set }
}

struct CoreDataEnvironmentImpl: CoreDataEnvironment {
    let savePublisher: CoreDataSavePublisher
    var insertPublisher: CoreDataInsertPublisher
    var fetchPublisher: CoreDataFetchPublisher<Todo>
    var deletePublisher: CoreDataDeletePublisher<Todo>

    init(savePublisher: CoreDataSavePublisher,
         insertPublisher: CoreDataInsertPublisher,
         fetchPublisher: CoreDataFetchPublisher<Todo>,
         deletePublisher: CoreDataDeletePublisher<Todo>) {
        self.savePublisher = savePublisher
        self.insertPublisher = insertPublisher
        self.fetchPublisher = fetchPublisher
        self.deletePublisher = deletePublisher
    }
}
