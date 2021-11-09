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
        let subscription =
        CoreDataDeletePublisher.Subscription(subscriber: subscriber,
                                             context: context,
                                             dataModel: dataModel)
        // 購読完了の通知
        subscriber.receive(subscription: subscription)
    }
}

extension CoreDataDeletePublisher {
    class Subscription<S> where S : Subscriber, Failure == S.Failure, Output == S.Input {
        // Sを使うためにextensionでインナークラスにしている
        private var subscriber: S?
        let context: NSManagedObjectContext
        let dataModel: DataModel

        init(subscriber: S,
             context: NSManagedObjectContext,
             dataModel: DataModel) {
            self.subscriber = subscriber
            self.context = context
            self.dataModel = dataModel
        }
    }
}

extension CoreDataDeletePublisher.Subscription: Subscription {
    func request(_ demand: Subscribers.Demand) {
        var demand = demand
        guard let subscriber = subscriber, demand > 0 else { return }
            demand -= 1
            context.delete(dataModel)
            demand += subscriber.receive(())
            subscriber.receive(completion: .finished)
    }

    func cancel() {
        subscriber = nil
    }
}
