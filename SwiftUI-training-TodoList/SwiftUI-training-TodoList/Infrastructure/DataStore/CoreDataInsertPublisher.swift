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
        // ここでアクションを実行して結果をsubscriberに返す
        // アクションの実行に必要な要素は初期化時にDIする
        let newTodo = Todo(context: context)
        newTodo.uuid = uuid
        newTodo.title = title
        newTodo.content = content
        newTodo.editDate = editDate

        do {
            try context.save()
            _ = subscriber.receive(newTodo)
            subscriber.receive(completion: .finished)
        } catch {
            subscriber.receive(completion: .failure(error))
        }

        // 購読完了の通知
        subscriber.receive(subscription: CoreDataSaveSubscription(combineIdentifier: CombineIdentifier()))
    }
}

struct CoreDataInsertSubscription: Subscription {
    let combineIdentifier: CombineIdentifier

    func request(_ demand: Subscribers.Demand) {}

    func cancel() {}
}
