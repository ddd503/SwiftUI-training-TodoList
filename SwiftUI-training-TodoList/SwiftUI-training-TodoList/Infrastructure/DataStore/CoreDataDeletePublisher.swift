//
//  CoreDataDeletePublisher.swift
//  SwiftUI-training-TodoList
//
//  Created by kawaharadai on 2021/10/09.
//

import Combine
import CoreData

struct CoreDataDeletePublisher<DataModel>: Publisher where DataModel: NSManagedObject {
    typealias Output = Void
    typealias Failure = Never

    let context: NSManagedObjectContext
    let dataModel: DataModel

    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        context.delete(dataModel)
        subscriber.receive(completion: .finished)
        // 購読完了の通知
        subscriber.receive(subscription: CoreDataDeleteSubscription(combineIdentifier: CombineIdentifier()))
    }
}

struct CoreDataDeleteSubscription: Subscription {
    let combineIdentifier: CombineIdentifier

    func request(_ demand: Subscribers.Demand) {}

    func cancel() {}
}
