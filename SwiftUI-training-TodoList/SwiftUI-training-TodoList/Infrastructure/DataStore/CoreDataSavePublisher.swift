//
//  CoreDataSavePublisher.swift
//  SwiftUI-training-TodoList
//
//  Created by kawaharadai on 2021/10/09.
//

import CoreData
import Combine

struct CoreDataSavePublisher: Publisher {
    typealias Output = Void
    typealias Failure = Error

    let context: NSManagedObjectContext

    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        let subscription = CoreDataSavePublisher.Subscription(subscriber: subscriber,
                                                              context: context)
        // 購読完了の通知
        subscriber.receive(subscription: subscription)
    }
}

extension CoreDataSavePublisher {
    class Subscription<S> where S : Subscriber, Failure == S.Failure, Output == S.Input {
        private var subscriber: S?
        let context: NSManagedObjectContext

        init(subscriber: S,
             context: NSManagedObjectContext) {
            self.subscriber = subscriber
            self.context = context
        }
    }
}

extension CoreDataSavePublisher.Subscription: Subscription {
    // 購読時毎に実行される処理
    func request(_ demand: Subscribers.Demand) {
        var demand = demand
        guard let subscriber = subscriber, demand > 0 else { return }
        do {
            demand -= 1
            try context.save()
            demand += subscriber.receive(())
//                subscriber.receive(completion: .finished)
        } catch {
            subscriber.receive(completion: .failure(error))
        }
    }

    func cancel() {
        subscriber = nil
    }
}
