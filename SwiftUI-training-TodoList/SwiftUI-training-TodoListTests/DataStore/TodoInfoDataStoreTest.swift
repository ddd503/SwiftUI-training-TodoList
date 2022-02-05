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

    private func contextMock(at count: Int) -> NSManagedObjectContext {
        CoreDataManager.hasTodoMock(at: count).container.viewContext
    }

    func test_create() {
        let expectation = self.expectation(description: "Todo&TodoInfo生成確認")
        var todoInfo: TodoInfo?
        var error: Error?
        let context = contextMock(at: 0)
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

        let context = contextMock(at: todoCount)
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
        // ソート順確認のため比較用に降順で並び替えた配列を用意
        let exepectListSort = todoInfoList.sorted { $0.editDate! > $1.editDate! }
        zip(todoInfoList, exepectListSort).forEach {
            XCTAssertEqual($0.0.id, $0.1.id)
        }
    }

    func test_update() {
        let expectation = self.expectation(description: "Todo更新確認")
        var todoInfo: TodoInfo?
        var error: Error?
        let context = contextMock(at: 0)
        let todoInfoDataStore = TodoInfoDataStoreImpl(coreDataEnvironment: CoreDataEnvironmentMock(context: context))

        let newTodo = Todo(context: context)
        newTodo.uuid = "999"
        newTodo.title = ""
        newTodo.content = ""
        newTodo.editDate = Date()

        try! context.save()

        let updateInfo = TodoInfo(id: newTodo.uuid!, title: "更新後タイトル", content: "更新後本文", editDate: nil)

        todoInfoDataStore.update(todoInfo: updateInfo)
            .flatMap({ _ in
                // Saveした結果がVoidのためreadし直す
                todoInfoDataStore.read()
            })
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let encounteredError):
                    error = encounteredError
                }
                expectation.fulfill()
            } receiveValue: { value in
                todoInfo = value.first!
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 0.5)

        XCTAssertNil(error)
        XCTAssertNotNil(todoInfo?.id)
        XCTAssertEqual(todoInfo?.title, updateInfo.title)
        XCTAssertEqual(todoInfo?.content, updateInfo.content)
        XCTAssertTrue(todoInfo?.editDate?.compare(newTodo.editDate!) == .orderedDescending ||
                      todoInfo?.editDate?.compare(newTodo.editDate!) == .orderedSame)
    }

    func test_delete() {
        let expectation = self.expectation(description: "Todo削除確認")
        var todoInfoList: [TodoInfo] = []
        var error: Error?
        let context = contextMock(at: 0)
        let todoInfoDataStore = TodoInfoDataStoreImpl(coreDataEnvironment: CoreDataEnvironmentMock(context: context))

        let newTodo1 = Todo(context: context)
        newTodo1.uuid = "1"
        let newTodo2 = Todo(context: context)
        newTodo2.uuid = "2"
        try! context.save()

        let deleteTodoInfo = TodoInfo(id: newTodo1.uuid!,
                                      title: newTodo1.title,
                                      content: newTodo1.content,
                                      editDate: newTodo1.editDate)

        todoInfoDataStore.delete(todoInfo: deleteTodoInfo)
            .flatMap({ _ in
                // Deleteした結果がVoidのためreadし直す
                todoInfoDataStore.read()
            })
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let encounteredError):
                    error = encounteredError
                }
                expectation.fulfill()
            } receiveValue: { value in
                todoInfoList = value
            }
            .store(in: &cancellables)

        waitForExpectations(timeout: 0.5)

        XCTAssertNil(error)
        XCTAssertFalse(todoInfoList.isEmpty)
        XCTAssertEqual(todoInfoList.first!.id, newTodo2.uuid)
        XCTAssertEqual(todoInfoList.first!.title, newTodo2.title)
        XCTAssertEqual(todoInfoList.first!.content, newTodo2.content)
        XCTAssertEqual(todoInfoList.first!.editDate, newTodo2.editDate)
    }

}

class CoreDataEnvironmentMock: CoreDataEnvironment {
    var savePublisher: CoreDataSavePublisher

    var insertPublisher: CoreDataInsertTodoPublisher

    var fetchPublisher: CoreDataFetchPublisher<Todo>

    var deletePublisher: CoreDataDeletePublisher<Todo>

    init(context: NSManagedObjectContext) {
        let savePublisher = CoreDataSavePublisher(context: context)
        let insertPublisher = CoreDataInsertTodoPublisher(context: context,
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
