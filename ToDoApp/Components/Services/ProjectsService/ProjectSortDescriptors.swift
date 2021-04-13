//
//  ProjectSortDescriptors.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 24.02.2021.
//

import CoreData

enum ProjectSortDescriptors: CustomStringConvertible {

	case nameAZ
	case nameZA
	case favoriteFirst
	case favoriteLast

	var sortDescriptor: NSSortDescriptor {
		switch self {
		case .nameAZ:
			let compareSelector = #selector(NSString.localizedStandardCompare(_:))
			return NSSortDescriptor(key: #keyPath(ProjectModel.name),
									ascending: true,
									selector: compareSelector)
		case .nameZA:
			let compareSelector = #selector(NSString.localizedStandardCompare(_:))
			let descriptor = NSSortDescriptor(key: #keyPath(ProjectModel.name),
											  ascending: true,
											  selector: compareSelector)
			return descriptor.reversedSortDescriptor as! NSSortDescriptor
		case .favoriteFirst:
			return NSSortDescriptor(key: #keyPath(ProjectModel.favorite),
									ascending: false)
		case .favoriteLast:
			return NSSortDescriptor(key: #keyPath(ProjectModel.favorite),
									ascending: true)
		}

	}

	var description: String {
		switch self {
		case .nameAZ:
			return R.string.localizable.projectDescriptor_nameAz()
		case .nameZA:
			return R.string.localizable.projectDescriptor_nameZa()
		case .favoriteFirst:
			return R.string.localizable.projectDescriptor_favoriteFirst()
		case .favoriteLast:
			return R.string.localizable.projectDescriptor_favoriteLast()
		}
	}

}
