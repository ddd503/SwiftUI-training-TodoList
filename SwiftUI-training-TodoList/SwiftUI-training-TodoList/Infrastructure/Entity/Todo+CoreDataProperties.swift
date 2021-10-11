//
//  Todo+CoreDataProperties.swift
//  SwiftUI-training-TodoList
//
//  Created by kawaharadai on 2021/10/09.
//
//

import Foundation
import CoreData


extension Todo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Todo> {
        return NSFetchRequest<Todo>(entityName: "Todo")
    }

    @NSManaged public var content: String?
    @NSManaged public var editDate: Date?
    @NSManaged public var uuid: String?
    @NSManaged public var title: String?

}

extension Todo : Identifiable {

}
