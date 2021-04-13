//
//  AddEditProjectScreenSections.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 09.03.2021.
//

import Foundation

enum AddEditProjectScreenSections {

	case projectName(TableViewSection)
	case projectColor(TableViewSection)
	case isFavorite(TableViewSection)
	case deleteProject(TableViewSection)

	var header: String {
		switch self {
		case .projectName(let model),
			 .projectColor(let model),
			 .isFavorite(let model),
			 .deleteProject(let model):
			return model.header
		}
	}

	var footer: String {
		switch self {
		case .projectName(let model),
			 .projectColor(let model),
			 .isFavorite(let model),
			 .deleteProject(let model):
			return model.footer
		}
	}

}
