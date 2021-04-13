//
//  TaskSortDescriptors.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 25.02.2021.
//

import Foundation

enum TaskSortDescriptors: CustomStringConvertible {

	case nameAZ
	case nameZA
	case dateAscending
	case dateDescending
	case createdAscending
	case createdDescending
	case priorityAscending
	case priorityDescending

	var sortDescriptor: NSSortDescriptor {
		switch self {
		case .nameAZ:
			let compareSelector = #selector(NSString.localizedStandardCompare(_:))
			return NSSortDescriptor(key: #keyPath(TaskModel.content),
									ascending: true,
									selector: compareSelector)
		case .nameZA:
			let compareSelector = #selector(NSString.localizedStandardCompare(_:))
			let descriptor = NSSortDescriptor(key: #keyPath(TaskModel.content),
											  ascending: true,
											  selector: compareSelector)
			return descriptor.reversedSortDescriptor as! NSSortDescriptor
		case .dateAscending: 
			return NSSortDescriptor(key: #keyPath(TaskModel.dueDate),
									ascending: true)
		case .dateDescending:
			return NSSortDescriptor(key: #keyPath(TaskModel.dueDate),
									ascending: false)
		case .createdAscending:
			return NSSortDescriptor(key: #keyPath(TaskModel.created),
									ascending: true)
		case .createdDescending:
			return NSSortDescriptor(key: #keyPath(TaskModel.created),
									ascending: false)

		case .priorityAscending:
			return NSSortDescriptor(key: #keyPath(TaskModel.priority),
									ascending: true)
		case .priorityDescending:
			return NSSortDescriptor(key: #keyPath(TaskModel.priority),
									ascending: false)
		}
	}

	var description: String {
		switch self {
		case .nameAZ:
			return R.string.localizable.taskDescriptor_nameAz()
		case .nameZA:
			return R.string.localizable.taskDescriptor_nameZa()
		case .dateAscending:
			return R.string.localizable.taskDescriptor_dateAscending()
		case .dateDescending:
			return R.string.localizable.taskDescriptor_dateDescending()
		case .createdAscending:
			return R.string.localizable.taskDescriptor_createdAscending()
		case .createdDescending:
			return R.string.localizable.taskDescriptor_createdDescending()
		case .priorityAscending:
			return R.string.localizable.taskDescriptor_priorityAscending()
		case .priorityDescending:
			return R.string.localizable.taskDescriptor_priorityDescending()
		}
	}

}
