//
//  TasksOrderStorage.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 17.03.2021.
//

import Foundation

final class TasksOrderStorage {

	private var tasksOrder = [nil, nil, TaskSortDescriptors.createdDescending]

	func orderOptionName(for section: TasksOrderingType) -> String? {
		guard let orderingSection = tasksOrder[section.rawValue] else { return nil }
		return orderingSection.description
	}

	func allSortDescriptors() -> [TaskSortDescriptors] {
		var descriptors = tasksOrder.compactMap({$0})
		descriptors.append(.nameAZ)
		return descriptors
	}

	func setOrdering(_ type: TasksOrderingType,
					 to orderingOption: TaskSortDescriptors) {
		if tasksOrder[type.rawValue] == orderingOption {
			tasksOrder[type.rawValue] = nil
		} else {
			(0...2).forEach { tasksOrder[$0] = nil }
			tasksOrder[type.rawValue] = orderingOption
		}
	}

	func reset() {
		tasksOrder.removeAll()
		tasksOrder = [nil, nil, TaskSortDescriptors.createdDescending]
	}

}

enum TasksOrderingType: Int {

	case byDate = 0
	case byPriority = 1
	case byCreationTime = 2

	var header: String {
		switch self {
		case .byDate:
			return R.string.localizable.tasksFiltersScreen_dateSection()
		case .byPriority:
			return R.string.localizable.tasksFiltersScreen_prioritySection()
		case .byCreationTime:
			return R.string.localizable.tasksFiltersScreen_creationSection()
		}
	}

}
