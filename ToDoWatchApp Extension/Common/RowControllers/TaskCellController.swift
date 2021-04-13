//
//  TaskCellController.swift
//  ToDoWatchApp Extension
//
//  Created by Mykhailo Yeroshenko on 08.04.2021.
//

import WatchKit

final class TaskCellController: NSObject {

	@IBOutlet private weak var titleLabel: WKInterfaceLabel!
	@IBOutlet private weak var priorityView: WKInterfaceSeparator!
	@IBOutlet weak var outdatedGroup: WKInterfaceGroup!
	@IBOutlet weak var outdatedIcon: WKInterfaceImage!

	func configureWith(task: Task) {
		titleLabel.setText(task.name)
		switch task.priority {
		case 1:
			priorityView.setColor(TodoistColor.lightGray.value)
		case 2:
			priorityView.setColor(TodoistColor.blue.value)
		case 3:
			priorityView.setColor(TodoistColor.orange.value)
		case 4:
			priorityView.setColor(TodoistColor.red.value)
		default:
			priorityView.setColor(.clear)
		}
		outdatedGroup.setHidden(!task.isOutdated)
		outdatedIcon.setTintColor(TodoistColor.red.value)
	}

}
