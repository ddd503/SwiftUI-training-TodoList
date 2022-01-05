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
        let context = CoreDataManager.hasTodoMock(at: 0).container.viewContext

        for i in 0..<todoCount {
            let newTodo = Todo(context: context)
            newTodo.uuid = "\(uuid)_\(i)"
            newTodo.title = "\(title)_\(i)"
            newTodo.content = "\(content)_\(i)"
            newTodo.editDate = editDate
            try! context.save()
        }
        let fetchRequest = NSFetchRequest<Todo>(entityName: "Todo")
        let publisher = CoreDataFetchPublisher(context: context,
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
