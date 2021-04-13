//
//  TaskFilteringPredicates.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 25.02.2021.
//

import CoreData

enum TaskFilteringPredicates {

	case hasId(Int)
	case hasName(String)
	case hasPriority(Int)
	case hasDate
	case hasSomeDate(Date)
	case dateRange(Date, Date)
	case hasNoDate
	case hasRelatedProject(Int)
	case wasCreatedOn(Date)
	case outdated
	case nameContains(String)
	case taskNameContains(phrase: String, projectId: Int)

	var predicate: NSPredicate {
		switch self {
		case .hasId(let id):
			return NSPredicate(format: "%K == \(id)",
							   #keyPath(TaskModel.identifier))
		case .hasName(let name):
			return NSPredicate(format: "%K == \(name)",
							   #keyPath(TaskModel.content))
		case .hasPriority(let priorityId):
			return NSPredicate(format: "%K == \(priorityId)",
							   #keyPath(TaskModel.priority))
		case .hasDate:
			return NSPredicate(format: "%K != nil",
							   #keyPath(TaskModel.dueDate))
		case .dateRange(let startDate, let finishDate):
			return NSPredicate(format: "(%K >= \(startDate)) && (%K <= \(finishDate)",
							   #keyPath(TaskModel.dueDate))
		case .hasSomeDate(let date):
			return NSPredicate(format: "%K == \(date)",
							   #keyPath(TaskModel.dueDate))
		case .hasNoDate:
			return NSPredicate(format: "%K == nil",
							   #keyPath(TaskModel.identifier))
		case .hasRelatedProject(let projectId):
			return NSPredicate(format: "%K == \(projectId)",
							   #keyPath(TaskModel.projectId))
		case .wasCreatedOn(let date):
			return NSPredicate(format: "%K == \(date)",
							   #keyPath(TaskModel.dueDate))
		case .outdated:
			return NSPredicate(format: "%K < \(Date())",
							   #keyPath(TaskModel.dueDate))
		case .nameContains(let name):
			return NSPredicate(format: "%K CONTAINS[C] '\(name)'",
							   #keyPath(TaskModel.content))
		case .taskNameContains(phrase: let name, projectId: let projectId):
			let predicates = [TaskFilteringPredicates.nameContains(name).predicate,
							  TaskFilteringPredicates.hasRelatedProject(projectId).predicate]
			return NSCompoundPredicate(type: .and, subpredicates: predicates)
		}
	}

}
