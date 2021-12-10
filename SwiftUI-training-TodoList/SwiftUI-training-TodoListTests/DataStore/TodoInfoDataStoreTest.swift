//
//  TodoInfoDataStoreTest.swift
//  SwiftUI-training-TodoListTests
//
//  Created by kawaharadai on 2021/10/30.
//

import XCTest
@testable import SwiftUI_training_TodoList

class TodoInfoDataStoreTest: XCTestCase {

    func test_create() {}

    func test_read() {}

    func test_update() {}

    func test_delete() {}

}

class CoreDataEnvironmentMock: CoreDataEnvironment {
    var savePublisher: CoreDataSavePublisher

    var insertPublisher: CoreDataInsertPublisher

    var fetchPublisher: CoreDataFetchPublisher<Todo>

    var deletePublisher: CoreDataDeletePublisher<Todo>
}
