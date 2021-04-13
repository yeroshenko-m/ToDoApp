//
//  ProjectsOrderStorage.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 17.03.2021.
//

import Foundation

final class ProjectsOrderStorage {

	private var projectsOrder: [ProjectsOrderingType: ProjectSortDescriptors] = [.byFavorite: .favoriteFirst]

	func orderOptionName(for section: ProjectsOrderingType) -> String? {
		projectsOrder[section]?.description
	}

	func allSortDescriptors() -> [ProjectSortDescriptors] {
		var sortDescriptors = projectsOrder.map { $0.value }
		sortDescriptors.append(.nameAZ)
		return sortDescriptors
	}

	func setOrdering(_ type: ProjectsOrderingType,
					 to orderingOption: ProjectSortDescriptors) {
		projectsOrder[type] = orderingOption
	}

	func reset() {
		projectsOrder.removeAll()
		projectsOrder = [.byFavorite: .favoriteFirst]
	}

}
