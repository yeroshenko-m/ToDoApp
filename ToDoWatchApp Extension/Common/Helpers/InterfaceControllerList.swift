//
//  InterfaceControllerList.swift
//  ToDoWatchApp Extension
//
//  Created by Mykhailo Yeroshenko on 08.04.2021.
//

import Foundation

enum InterfaceController {

	case main,
		 projectsList,
		 projectDetails,
		 taskList,
		 taskDetails,
		 schedule

	var name: String {
		switch self {
		case .main:
			return MainInterfaceController.nameOfController
		case .projectDetails:
			return ProjectDetailsInterfaceController.nameOfController
		case .projectsList:
			return ProjectsListInterfaceController.nameOfController
		case .taskList:
			return TasksListInterfaceController.nameOfController
		case .taskDetails:
			return TaskDetailsInterfaceController.nameOfController
		case .schedule:
			return ScheduleInterfaceController.nameOfController
		}
	}

}
