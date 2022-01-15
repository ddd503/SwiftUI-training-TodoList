//
//  CoreDataDeletePublisherTest.swift
//  SwiftUI-training-TodoListTests
//
//  Created by kawaharadai on 2022/01/15.
//

import XCTest
import CoreData
import Combine
@testable import SwiftUI_training_TodoList

class CoreDataDeletePublisherTest: XCTestCase {
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        cancellables = []
    }
    
    func test_receive() {
        let expectation = self.expectation(description: "Todo削除確認")
        var todoList: [Todo] = []
        let context = CoreDataManager.hasTodoMock(at: 0).container.viewContext

        let newTodo1 = Todo(context: context)
        newTodo1.uuid = "1"
        let newTodo2 = Todo(context: context)
        newTodo2.uuid = "2"
        try! context.save()

        let publisher = CoreDataDeletePublisher(context: context, dataModel: newTodo1)

        publisher.sink { completion in
            switch completion {
            case .finished:
                let fetchRequest = NSFetchRequest<Todo>(entityName: "Todo")
                todoList = try! context.fetch(fetchRequest)
                break
            case .failure:
                break
            }
            expectation.fulfill()
        } receiveValue: {_ in }
        .store(in: &cancellables)

        waitForExpectations(timeout: 0.5)

        XCTAssertEqual(todoList.count, 1)
        XCTAssertEqual(todoList.first!.uuid, newTodo2.uuid)
    }
}
