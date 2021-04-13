//
//  ProjectModel+CoreDataProperties.swift
//  
//
//  Created by Mykhailo Yeroshenko on 10.03.2021.
//
//

import CoreData

extension ProjectModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProjectModel> {
        return NSFetchRequest<ProjectModel>(entityName: "ProjectModel")
    }

    @NSManaged public var color: Int16
    @NSManaged public var favorite: Bool
    @NSManaged public var identifier: Int64
    @NSManaged public var name: String?
	@NSManaged public var tasks: NSSet?

}

// MARK: Generated accessors for tasks
extension ProjectModel {

	@objc(addTasksObject:)
	@NSManaged public func addToTasks(_ value: TaskModel)

	@objc(removeTasksObject:)
	@NSManaged public func removeFromTasks(_ value: TaskModel)

	@objc(addTasks:)
	@NSManaged public func addToTasks(_ values: NSSet)

	@objc(removeTasks:)
	@NSManaged public func removeFromTasks(_ values: NSSet)

}
