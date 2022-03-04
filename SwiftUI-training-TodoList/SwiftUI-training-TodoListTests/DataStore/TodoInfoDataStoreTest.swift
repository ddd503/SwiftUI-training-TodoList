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

    func test_create_insert成功() {
        let expectation = self.expectation(description: "InsertされたTodo情報をTodoInfoとして取得できること")
        var todoInfo: TodoInfo?
        var error: Error?
        let coreDataEnvironment = CoreDataEnvironmentMock()
        let context = contextMock(at: 0)
        let createdTodo = Todo(context: context)
        createdTodo.uuid = "uuid"
        createdTodo.title = "title"
        createdTodo.content = "content"
        createdTodo.editDate = Date()
        coreDataEnvironment.insertTodoPublisher.todo = createdTodo
        let todoInfoDataStore = TodoInfoDataStoreImpl(coreDataEnvironment: coreDataEnvironment)
        todoInfoDataStore.create(title: createdTodo.title!,
                                 content: createdTodo.content)
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
        XCTAssertEqual(todoInfo!.id, createdTodo.uuid)
        XCTAssertEqual(todoInfo!.title, createdTodo.title)
        XCTAssertEqual(todoInfo!.content, createdTodo.content)
        XCTAssertEqual(todoInfo!.editDate, createdTodo.editDate)
    }

    func test_create_insert失敗() {
        let expectation = self.expectation(description: "Insert失敗エラーをハンドリングできること")
        var todoInfo: TodoInfo?
        var error: Error?
        let coreDataEnvironment = CoreDataEnvironmentMock()
        struct InsertError: Error {}
        let returnError = InsertError()
        coreDataEnvironment.insertTodoPublisher.isFailedInsert = true
        coreDataEnvironment.insertTodoPublisher.error = returnError
        let todoInfoDataStore = TodoInfoDataStoreImpl(coreDataEnvironment: coreDataEnvironment)
        todoInfoDataStore.create(title: "", content: "")
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

        XCTAssertNil(todoInfo)
        XCTAssertTrue(error is InsertError)
    }

    func test_read() {
        let expectation = self.expectation(description: "Todo取得確認")
        let todoCount = 10
        var todoInfoList: [TodoInfo] = []
        var error: Error?

        let coreDataEnvironment = CoreDataEnvironmentMock()
        // ここで10個インサートする必要あり
        let todoInfoDataStore = TodoInfoDataStoreImpl(coreDataEnvironment: coreDataEnvironment)

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
        let todoInfoDataStore = TodoInfoDataStoreImpl(coreDataEnvironment: CoreDataEnvironmentMock())

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
        let todoInfoDataStore = TodoInfoDataStoreImpl(coreDataEnvironment: CoreDataEnvironmentMock())

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
    var savePublisher: CoreDataSavePublisher!
    var insertTodoPublisher: CoreDataInsertTodoPublisherMock!
    var fetchPublisher: CoreDataFetchPublisher<Todo>!
    var deletePublisher: CoreDataDeletePublisher<Todo>!

    init(insertTodoPublisher: CoreDataInsertTodoPublisherMock = CoreDataInsertTodoPublisherMock()) {
        self.insertTodoPublisher = insertTodoPublisher
    }

    func saveDataPublisher() -> AnyPublisher<Void, Error> {
        savePublisher.eraseToAnyPublisher()
    }

    func insertTodoAnyPublisher(title: String, content: String?) -> AnyPublisher<Todo, Error> {
        insertTodoPublisher.title = title
        insertTodoPublisher.content = content
        return insertTodoPublisher.eraseToAnyPublisher()
    }

    func fetchTodoPublisher(fetchRequest: NSFetchRequest<Todo>) -> AnyPublisher<[Todo], Error> {
        fetchPublisher.request = fetchRequest
        return fetchPublisher.eraseToAnyPublisher()
    }

    func deleteTodoPublisher(todo: Todo) -> AnyPublisher<Void, Never> {
        deletePublisher.dataModel = todo
        return deletePublisher.eraseToAnyPublisher()
    }
}
