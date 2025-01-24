//
//  ToDoList+CoreDataProperties.swift
//  TestProject
//
//  Created by Дмитрий Забиякин on 23.01.2025.
//
//

import Foundation
import CoreData

@objc(ToDoList)
public class ToDoList: NSManagedObject {

}

extension ToDoList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoList> {
        return NSFetchRequest<ToDoList>(entityName: "ToDoList")
    }

    @NSManaged public var commentToDo: String?
    @NSManaged public var completed: Bool
    @NSManaged public var date: Date?
    @NSManaged public var todo: String?

}

extension ToDoList : Identifiable {

}
