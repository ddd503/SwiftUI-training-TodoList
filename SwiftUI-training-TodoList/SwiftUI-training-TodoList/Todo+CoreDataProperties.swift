//
//  Todo+CoreDataProperties.swift
//  SwiftUI-training-TodoList
//
//  Created by kawaharadai on 2021/08/20.
//
//

import Foundation
import CoreData


extension Todo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Todo> {
        return NSFetchRequest<Todo>(entityName: "Todo")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var content: String?
    @NSManaged public var editDate: Date?

}

extension Todo : Identifiable {

}
