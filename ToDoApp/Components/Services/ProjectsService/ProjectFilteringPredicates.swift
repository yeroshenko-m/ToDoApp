//
//  ProjectFilteringPredicates.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 24.02.2021.
//

import CoreData

enum ProjectFilteringPredicates {

	case hasId(Int)
	case hasColor(Int)
	case isFavorite
	case nameContains(String)

	var predicate: NSPredicate {
		switch self {
		case .isFavorite:
			return NSPredicate(format: "%K == true",
							   #keyPath(ProjectModel.favorite))
		case .hasColor(let colorId):
			return NSPredicate(format: "%K == \(colorId)",
							   #keyPath(ProjectModel.color))
		case .hasId(let projectId):
			return NSPredicate(format: "%K == \(projectId)",
							   #keyPath(ProjectModel.identifier))
		case .nameContains(let name):
			return NSPredicate(format: "%K CONTAINS[C] '\(name)'",
							   #keyPath(ProjectModel.name))
		}
	}

}
