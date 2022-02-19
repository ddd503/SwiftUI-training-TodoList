//
//  CoreDataInsertTodoPublisherMock.swift
//  SwiftUI-training-TodoListTests
//
//  Created by kawaharadai on 2022/02/11.
//

import Combine
@testable import SwiftUI_training_TodoList

final class CoreDataInsertTodoPublisherMock: Publisher {
    typealias Output = Todo
    typealias Failure = Error
    var title: String?
    var content: String?
    var isFailedInsert = false
    var todo: Todo?
    var error: Error?

    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        let subscription = CoreDataInsertTodoPublisherMock.Subscription(subscriber: subscriber, isFailedInsert: isFailedInsert, todo: todo, error: error)
        subscriber.receive(subscription: subscription)
    }

    // S型でsubscriberを保持するためインナークラスにしている
    class Subscription<S> where S : Subscriber, Failure == S.Failure, Output == S.Input {
        private var subscriber: S?
        private let isFailedInsert: Bool
        private let todo: Todo?
        private let error: Error?

        init(subscriber: S, isFailedInsert: Bool, todo: Todo?, error: Error?) {
            self.subscriber = subscriber
            self.isFailedInsert = isFailedInsert
            self.todo = todo
            self.error = error
        }
    }
}

extension CoreDataInsertTodoPublisherMock.Subscription: Subscription {
    func request(_ demand: Subscribers.Demand) {
        var demand = demand
        guard demand > 0 else { return }
        if isFailedInsert {
            subscriber!.receive(completion: .failure(error!))
        } else {
            demand -= 1
            demand += subscriber!.receive(todo!)
            subscriber!.receive(completion: .finished)
        }
    }

    func cancel() {
        self.subscriber = nil
    }
}

