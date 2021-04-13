//
//  AddEditTaskCoordinatorProtocol.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 04.04.2021.
//

import Foundation

protocol AddEditTaskCoordinator: Coordinator {
	func finish()
	func changeDate(from currentDate: Date?)
	func dateChanged(to newDate: Date?)
	func changePriority(from currentPriority: Priority)
	func priorityChanged(to newPriority: Priority)
}

extension AddEditTaskCoordinator {

	func changeDate(from currentDate: Date?) {
		let datePickerVC = DatePickerViewController.controller(in: .projectDetails)
		datePickerVC.onDateChangedAction = dateChanged(to:)
		datePickerVC.currentDate = currentDate
		navController.show(datePickerVC, sender: nil)
	}

	func dateChanged(to newDate: Date?) {
		navController.viewControllers.forEach {
			($0 as? UpdatableWithTaskInfo)?.setDate(newDate)
		}
		navController.popViewController(animated: true)
	}

	func changePriority(from currentPriority: Priority) {
		let selectPriorityVC = SelectTaskPriorityViewController.controller(in: .projectDetails)
		selectPriorityVC.onPriorityChangedAction = priorityChanged(to:)
		selectPriorityVC.selectedPriority = currentPriority
		navController.show(selectPriorityVC, sender: nil)
	}

	func priorityChanged(to newPriority: Priority) {
		navController.viewControllers.forEach {
			($0 as? UpdatableWithTaskInfo)?.setPriority(newPriority)
		}
		navController.popViewController(animated: true)
	}
}
