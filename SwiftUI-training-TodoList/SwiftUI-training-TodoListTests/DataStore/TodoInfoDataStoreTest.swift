//
//  TodoInfoDataStoreTest.swift
//  SwiftUI-training-TodoListTests
//
//  Created by kawaharadai on 2021/10/30.
//

import XCTest
import CoreData
import Combine
@testable import SwiftUI_training_TodoList

class TodoInfoDataStoreTest: XCTestCase {
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        cancellables = []
    }

    func test_create() {
        let expectation = self.expectation(description: "Todo&TodoInfo生成確認")
        var todoInfo: TodoInfo?
        var error: Error?
        let context = CoreDataManager.emptyMock.container.viewContext
        let todoInfoDataStore = TodoInfoDataStoreImpl(coreDataEnvironment: CoreDataEnvironmentMock(context: context))
        let testTitle = "テストタイトル"
        let testContent = "テスト本文"
        todoInfoDataStore.create(title: testTitle,
                                 content: testContent)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let encounteredError):
                    error = encounteredError
                }
                expectation.fulfill()
            } receiveValue: { value in
                todoInfo = value
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 0.5)

        XCTAssertNil(error)
        XCTAssertNotNil(todoInfo?.id)
        XCTAssertEqual(todoInfo?.title, testTitle)
        XCTAssertEqual(todoInfo?.content, testContent)
        XCTAssertNotNil(todoInfo?.editDate)
    }

    func test_read() {
        let expectation = self.expectation(description: "Todo取得確認")
        let todoCount = 10
        var todoInfoList: [TodoInfo] = []
        var error: Error?

        let context = CoreDataManager.hasTodoMock(at: todoCount).container.viewContext
        let todoInfoDataStore = TodoInfoDataStoreImpl(coreDataEnvironment: CoreDataEnvironmentMock(context: context))

        todoInfoDataStore.read()
            .sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let publisherError):
                error = publisherError
            }
            expectation.fulfill()
        } receiveValue: { value in
            todoInfoList = value
        }
        .store(in: &cancellables)

        waitForExpectations(timeout: 0.5)

        XCTAssertNil(error)
        XCTAssertEqual(todoInfoList.count, todoCount)
        let exepectListSort = todoInfoList.sorted { Int($0.id)! > Int($1.id)! } // 降順で並び替え
        zip(todoInfoList, exepectListSort).forEach {
            XCTAssertEqual($0.0.id, $0.1.id)
        }
    }

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
