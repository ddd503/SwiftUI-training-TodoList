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
    let insertAction: () -> (Todo)

    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        // subscriberの登録
        // 購読時に実行する処理を登録
        let subscription =
        CoreDataInsertPublisher.Subscription(subscriber: subscriber,
                                             context: context,
                                             insertAction: insertAction)
        subscriber.receive(subscription: subscription)
    }
}

extension CoreDataInsertPublisher {
    class Subscription<S> where S : Subscriber, Failure == S.Failure, Output == S.Input {
        // Sを使うためにextensionでインナークラスにしている
        private var subscriber: S?
        let context: NSManagedObjectContext
        let insertAction: () -> (Todo)

        init(subscriber: S,
             context: NSManagedObjectContext,
             insertAction: @escaping () -> (Todo)) {
            self.subscriber = subscriber
            self.context = context
            self.insertAction = insertAction
        }
    }
}

extension CoreDataInsertPublisher.Subscription: Subscription {
    // 購読時毎に実行される処理
    func request(_ demand: Subscribers.Demand) {
        var demand = demand
        guard let subscriber = subscriber, demand > 0 else { return }

        do {
            demand -= 1
            let todo = insertAction()
            try context.save()
            demand += subscriber.receive((todo))
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
