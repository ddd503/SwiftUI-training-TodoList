//
//  CoreDataFetchPublisherTest.swift
//  SwiftUI-training-TodoListTests
//
//  Created by kawaharadai on 2021/12/29.
//

import XCTest
import CoreData
import Combine
@testable import SwiftUI_training_TodoList

class CoreDataFetchPublisherTest: XCTestCase {

    // 参照の都度イニシャライズして書き換えていく
    private var contextMock: NSManagedObjectContext {
        CoreDataManager.emptyMock.container.viewContext
    }
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        cancellables = []
    }

    func test_receive() {
        let expectation = self.expectation(description: "Todo取得確認")
        var todoList: [Todo] = []
        var error: Error?
        let todoCount = 3
        let uuid = "testUUID"
        let title = "testTitle"
        let content = "testContent"
        let editDate = Date()

        for i in 0..<todoCount {
            let newTodo = Todo(context: contextMock)
            newTodo.uuid = "\(uuid)_\(i)"
            newTodo.title = "\(title)_\(i)"
            newTodo.content = "\(content)_\(i)"
            newTodo.editDate = editDate
            try! contextMock.save()
        }
        let fetchRequest = NSFetchRequest<Todo>(entityName: "Todo")
        let publisher = CoreDataFetchPublisher(context: contextMock,
                                               request: fetchRequest)

        publisher.sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let publisherError):
                error = publisherError
            }
            expectation.fulfill()
        } receiveValue: { value in
            todoList = value
        }
        .store(in: &cancellables)

        waitForExpectations(timeout: 0.5)

        XCTAssertNil(error)
        XCTAssertEqual(todoList.count, todoCount)
    }
}
