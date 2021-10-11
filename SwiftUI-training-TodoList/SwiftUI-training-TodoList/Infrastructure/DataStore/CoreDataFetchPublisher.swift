//
//  CoreDataFetchPublisher.swift
//  SwiftUI-training-TodoList
//
//  Created by kawaharadai on 2021/10/09.
//

import Combine
import CoreData

struct CoreDataFetchPublisher<DataModel>: Publisher where DataModel: NSManagedObject {
    typealias Output = [DataModel]
    typealias Failure = Error

    let context: NSManagedObjectContext
    let request: NSFetchRequest<DataModel>
    
    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        do {
            let result = try context.fetch(request)
            _ = subscriber.receive(result)
            subscriber.receive(completion: .finished)
        } catch {
            subscriber.receive(completion: .failure(error))
        }
        
        subscriber.receive(subscription: CoreDataFetchSubscription(combineIdentifier: CombineIdentifier()))
    }
}

struct CoreDataFetchSubscription: Subscription {
    let combineIdentifier: CombineIdentifier

    func request(_ demand: Subscribers.Demand) {}

    func cancel() {}
}

