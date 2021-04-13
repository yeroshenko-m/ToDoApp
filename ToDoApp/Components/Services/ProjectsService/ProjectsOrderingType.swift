//
//  ProjectsOrderingType.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 04.04.2021.
//

import Foundation

enum ProjectsOrderingType {

	case byFavorite

	var header: String {
		switch self {
		case .byFavorite:
			return R.string.localizable.projectFiltersScreen_favoriteSection()
		}
	}

}
