//
//  TaskCellViewModel.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 02.02.2021.
//

import UIKit

struct TaskCellDisplayObject {

    let task: Task
    
    var name: String {
		task.name
	}

	var taskDueDate: String {
		task.due ?? String()
	}

    var taskPriorityName: String {
		Priority(rawValue: task.priority).description
	}

    var priorityColor: UIColor {
		Priority(rawValue: task.priority).color
	}

}

extension TaskCellDisplayObject: CellViewModel {

    func setup(cell: TaskCell) {
        cell.taskNameLabel.text = name
        cell.taskPriorityLabel.text = taskPriorityName
        cell.taskPriorityLabel.textColor = priorityColor
        cell.taskPriorityImage.tintColor = priorityColor
		cell.dateLabel.text = DateFormatter().dateTimeString(from: taskDueDate)
        cell.dueStack.isHidden = taskDueDate.isEmpty
		guard let taskDate = DateFormatter().dateFromRFC3339String(taskDueDate)
		else {
			cell.isOutdated = false
			return
		}
		let currentDate = Date()
		cell.isOutdated = currentDate > taskDate
    }

}
