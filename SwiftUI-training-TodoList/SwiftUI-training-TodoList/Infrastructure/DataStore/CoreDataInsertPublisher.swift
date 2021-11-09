//
//  CoreDataInsertPublisher.swift
//  SwiftUI-training-TodoList
//
//  Created by kawaharadai on 2021/10/11.
//

import CoreData
import Combine

struct CoreDataInsertPublisher: Publisher {
    typealias Output = Todo
    typealias Failure = Error

    let context: NSManagedObjectContext
    let uuid: String
    let title: String
    let content: String?
    let editDate: Date

    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        // subscriberの登録
        // 購読時に実行する処理を登録
        let subscription =
        CoreDataInsertPublisher.Subscription(subscriber: subscriber,
                                             context: context,
                                             uuid: uuid,
                                             title: title,
                                             content: content,
                                             editDate: editDate)
        subscriber.receive(subscription: subscription)
    }
}

extension CoreDataInsertPublisher {
    class Subscription<S> where S : Subscriber, Failure == S.Failure, Output == S.Input {
        // Sを使うためにextensionでインナークラスにしている
        private var subscriber: S?
        let context: NSManagedObjectContext
        let uuid: String
        let title: String
        let content: String?
        let editDate: Date

        init(subscriber: S,
             context: NSManagedObjectContext,
             uuid: String,
             title: String,
             content: String?,
             editDate: Date) {
            self.subscriber = subscriber
            self.context = context
            self.uuid = uuid
            self.title = title
            self.content = content
            self.editDate = editDate
        }
    }
}

extension CoreDataInsertPublisher.Subscription: Subscription {
    // 購読時毎に実行される処理
    func request(_ demand: Subscribers.Demand) {
        var demand = demand
        guard let subscriber = subscriber, demand > 0 else { return }

        let newTodo = Todo(context: context)
        newTodo.uuid = uuid
        newTodo.title = title
        newTodo.content = content
        newTodo.editDate = editDate

        do {
            demand -= 1
            try context.save()
            demand += subscriber.receive(newTodo)
            subscriber.receive(completion: .finished)
        } catch {
            subscriber.receive(completion: .failure(error))
        }
    }

    func cancel() {
        // 購読キャンセル時はsubscriberをnilにして購読登録なくす
        subscriber = nil
    }
}
