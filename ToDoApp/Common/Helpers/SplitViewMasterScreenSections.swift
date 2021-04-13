//
//  SplitMenuScreenSections.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 07.04.2021.
//

import UIKit

enum SplitMenuScreenSections: String, CaseIterable {

	case allProjects, allTasks, settings

	var name: String {
		switch self {
		case .allProjects:
			return R.string.localizable.splitMenu_allProjects()
		case .allTasks:
			return R.string.localizable.splitMenu_allTasks()
		case .settings:
			return R.string.localizable.splitMenu_settings()
		}
	}

	var image: UIImage {
		switch self {
		case .allProjects:
			return R.image.folder()!.withRenderingMode(.alwaysTemplate)
		case .allTasks:
			return R.image.stackFill()!.withRenderingMode(.alwaysTemplate)
		case .settings:
			return R.image.gearFill()!.withRenderingMode(.alwaysTemplate)
		}
	}

}
