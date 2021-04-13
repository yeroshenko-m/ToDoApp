//
//  AddEditTaskScreenSections.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 09.03.2021.
//

import Foundation

enum AddEditTaskScreenSections {

	case taskName(TableViewSection)
	case dueDate(TableViewSection)
	case taskPriority(TableViewSection)
	case taskProject(TableViewSection)
	case deleteTask(TableViewSection)

	var header: String {
		switch self {
		case .taskName(let model),
			 .dueDate(let model),
			 .taskPriority(let model),
			 .taskProject(let model),
			 .deleteTask(let model):
			return model.header
		}
	}

	var footer: String { 
		switch self {
		case .taskName(let model),
			 .dueDate(let model),
			 .taskPriority(let model),
			 .taskProject(let model),
			 .deleteTask(let model):
			return model.footer
		}
	}

}
