//
//  TaskModel+CoreDataProperties.swift
//  
//
//  Created by Mykhailo Yeroshenko on 10.03.2021.
//
//

import CoreData

extension TaskModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskModel> {
        return NSFetchRequest<TaskModel>(entityName: "TaskModel")
    }

    @NSManaged public var completed: Bool
    @NSManaged public var content: String?
    @NSManaged public var created: Date?
    @NSManaged public var dueDate: Date?
    @NSManaged public var identifier: Int64
    @NSManaged public var priority: Int16
    @NSManaged public var projectId: Int64
    @NSManaged public var url: URL?
    @NSManaged public var project: ProjectModel?

}
