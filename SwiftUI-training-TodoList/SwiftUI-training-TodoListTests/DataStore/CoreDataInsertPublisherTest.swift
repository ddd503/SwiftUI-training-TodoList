//
//  CoreDataInsertPublisherTest.swift
//  SwiftUI-training-TodoListTests
//
//  Created by kawaharadai on 2021/12/26.
//

import XCTest
import CoreData
import Combine
@testable import SwiftUI_training_TodoList

class CoreDataInsertPublisherTest: XCTestCase {
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        cancellables = []
    }

    func test_receive() {
        let expectation = self.expectation(description: "Todo生成確認")
        var todo: Todo?
        var error: Error?
        let uuid = "testUUID"
        let title = "testTitle"
        let content = "testContent"
        let editDate = Date()
        let context = CoreDataManager.hasTodoMock(at: 0).container.viewContext
        let publisher = CoreDataInsertTodoPublisher(context: context,
                                                uuid: uuid,
                                                title: title,
                                                content: content,
                                                editDate: editDate)

        publisher.sink { completion in
            switch completion {
            case .finished:
                let fetchRequest = NSFetchRequest<Todo>(entityName: "Todo")
                do {
                    todo = try context.fetch(fetchRequest).first
                } catch(let saveError) {
                    error = saveError
                }
                break
            case .failure(let publisherError):
                error = publisherError
            }
            expectation.fulfill()
        } receiveValue: {_ in }
        .store(in: &cancellables)

        waitForExpectations(timeout: 0.5)

        XCTAssertNil(error)
        XCTAssertEqual(todo?.uuid, uuid)
        XCTAssertEqual(todo?.title, title)
        XCTAssertEqual(todo?.content, content)
        XCTAssertEqual(todo?.editDate, editDate)
    }
}
