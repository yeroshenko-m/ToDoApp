//
//  RowControllerType.swift
//  ToDoWatchApp Extension
//
//  Created by Mykhailo Yeroshenko on 08.04.2021.
//

import Foundation

enum RowControllerType {

	case mainMenuCell,
		 projectCell,
		 taskCell,
		 tableSectionCell,
		 emptySectionCell

	var type: String {
		switch self {
		case .mainMenuCell:
			return MainMenuCellController.nameOfClass
		case .projectCell:
			return ProjectCellController.nameOfClass
		case .taskCell:
			return TaskCellController.nameOfClass
		case .tableSectionCell:
			return TableSectionCellController.nameOfClass
		case .emptySectionCell:
			return EmptySectionRowController.nameOfClass
		}
	}

}
