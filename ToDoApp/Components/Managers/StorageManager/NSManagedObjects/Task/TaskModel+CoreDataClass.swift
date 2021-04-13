//
//  TaskModel+CoreDataClass.swift
//  
//
//  Created by Mykhailo Yeroshenko on 10.03.2021.
//
//

import CoreData

@objc(TaskModel)
public class TaskModel: NSManagedObject {
	
	var asTask: Task {
		return Task(id: Int(identifier),
			 name: content ?? "Undefined",
			 projectId: Int(projectId),
			 created: created != nil ? DateFormatter().stringRFC3339FromDate(created!) : String(),
			 due: dueDate != nil ? DateFormatter().stringRFC3339FromDate(dueDate!): String(),
			 priority: Int(priority),
			 projectName: project?.name ?? String())

	}
	
}

extension TaskModel: DTOConfigurable {

	func hasDifferences<Object: DataTransferObject>(from object: Object) throws -> Bool {
		guard let taskDTO = object as? TaskDTO else { throw DTOCastingError.objectTypeMismatch }
		let taskDueDate = DateFormatter().dateFromRFC3339String(taskDTO.due?.datetime)
		if taskDTO.id == identifier,
		   taskDTO.projectId == projectId,
		   taskDTO.content == content,
		   taskDTO.completed == completed,
		   taskDueDate == dueDate,
		   taskDTO.priority == priority,
		   taskDueDate == dueDate {
			return false
		}
		return true
	}
	
	func configure<Object: DataTransferObject>(withObject object: Object) {
		guard let object = object as? TaskDTO else { return }
		completed = object.completed
		content = object.content
		created = DateFormatter().dateFromRFC3339String(object.created)
		identifier = .init(clamping: object.id)
		priority = .init(clamping: object.priority)
		projectId = .init(clamping: object.projectId)
		url = URL(string: object.url) ?? nil
		
		if let due = object.due {
			dueDate = DateFormatter().dateFromRFC3339String(due.datetime)
		} else {
			dueDate = nil
		}
	}

	func update(withObject object: ToDoObject) {
		guard let task = object as? Task else { return }
		content = task.name
		projectId = Int64(task.projectId)
		priority = Int16(task.priority)
		if let dueDateString = task.due,
		   let taskDueDate = DateFormatter().dateFromRFC3339String(dueDateString) {
			dueDate = taskDueDate
		} else {
			dueDate = nil
		}

	}

}
