//
//  TodoInfoDataStoreTest.swift
//  SwiftUI-training-TodoListTests
//
//  Created by kawaharadai on 2021/10/30.
//

import XCTest
import CoreData
@testable import SwiftUI_training_TodoList

class TodoInfoDataStoreTest: XCTestCase {

    func test_create() {
        let todoInfoDataStore = TodoInfoDataStoreImpl(coreDataEnvironment: CoreDataEnvironmentMock(context: CoreDataManager.emptyMock.container.viewContext))
    }

    func test_read() {}

    func test_update() {}

    func test_delete() {}

}

class CoreDataEnvironmentMock: CoreDataEnvironment {
    var savePublisher: CoreDataSavePublisher

    var insertPublisher: CoreDataInsertPublisher

    var fetchPublisher: CoreDataFetchPublisher<Todo>

    var deletePublisher: CoreDataDeletePublisher<Todo>

    init(context: NSManagedObjectContext) {
        let savePublisher = CoreDataSavePublisher(context: context)
        let insertPublisher = CoreDataInsertPublisher(context: context,
                                                      uuid: UUID().uuidString,
                                                      editDate: Date())
        let fetchRequest = NSFetchRequest<Todo>(entityName: "Todo")
        let fetchPublisher = CoreDataFetchPublisher<Todo>(context: context,
                                                          request: fetchRequest)
        let deletePublisher = CoreDataDeletePublisher<Todo>(context: context, dataModel: nil)

        self.savePublisher = savePublisher
        self.insertPublisher = insertPublisher
        self.fetchPublisher = fetchPublisher
        self.deletePublisher = deletePublisher
    }
}
