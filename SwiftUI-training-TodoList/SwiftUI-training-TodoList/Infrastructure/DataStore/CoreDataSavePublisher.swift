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
        do {
            try context.save()
            subscriber.receive(completion: .finished)
        } catch {
            subscriber.receive(completion: .failure(error))
        }

        // 購読完了の通知
        subscriber.receive(subscription: CoreDataSaveSubscription(combineIdentifier: CombineIdentifier()))
    }
}

struct CoreDataSaveSubscription: Subscription {
    let combineIdentifier: CombineIdentifier

    func request(_ demand: Subscribers.Demand) {}

    func cancel() {}
}
