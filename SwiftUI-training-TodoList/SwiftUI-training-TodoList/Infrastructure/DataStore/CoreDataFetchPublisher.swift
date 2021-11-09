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
        let subscription =
        CoreDataFetchPublisher.Subscription(subscriber: subscriber,
                                            context: context,
                                            request: request)
        subscriber.receive(subscription: subscription)
    }
}

extension CoreDataFetchPublisher {
    class Subscription<S> where S : Subscriber, Failure == S.Failure, Output == S.Input {
        // Sを使うためにextensionでインナークラスにしている
        private var subscriber: S?
        let context: NSManagedObjectContext
        let request: NSFetchRequest<DataModel>

        init(subscriber: S,
             context: NSManagedObjectContext,
             request: NSFetchRequest<DataModel>) {
            self.subscriber = subscriber
            self.context = context
            self.request = request
        }
    }
}

extension CoreDataFetchPublisher.Subscription: Subscription {
    func request(_ demand: Subscribers.Demand) {
        var demand = demand
        guard let subscriber = subscriber, demand > 0 else { return }

        do {
            demand -= 1
            let result = try context.fetch(request)
            demand += subscriber.receive(result)
//            subscriber.receive(completion: .finished)
        } catch {
            subscriber.receive(completion: .failure(error))
        }
    }

    func cancel() {
        subscriber = nil
    }
}

