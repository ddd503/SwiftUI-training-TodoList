//
//  CoreDataManager.swift
//  SwiftUI-training-TodoList
//
//  Created by kawaharadai on 2021/09/11.
//

import CoreData

struct CoreDataManager {
    static let shared = CoreDataManager()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "SwiftUI_training_TodoList")
        if inMemory {
            // オンメモリーで使う場合はurlを"/dev/null"としておけば良い
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                /*
                 本来はここでエラーログを送るなどをする必要がある
                 エラーの主な原因
                 - 親ディレクトリが存在しない、作成できない、または書き込みが禁止されている。
                 - 親ディレクトリが存在しない、作成できない、または書き込みが禁止されている
                 - デバイスがロックされているときのパーミッションやデータ保護のために、永続ストアにアクセスできない
                 - デバイスの容量が不足している。
                 - デバイスの空き容量が不足しています。
                 - ストアを現在のモデルバージョンに移行できませんでした。
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }

    static var preview: CoreDataManager = {
        let result = CoreDataManager(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let todo = Todo(context: viewContext)
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
}
