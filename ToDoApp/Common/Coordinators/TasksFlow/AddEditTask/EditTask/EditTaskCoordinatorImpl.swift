//
//  EditTaskCoordinator.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 11.03.2021.
//

import UIKit

final class EditTaskCoordinatorImpl: AddEditTaskCoordinator {

	// MARK: - Properties

	var onFinishEditingTaskAction: ((EditTaskCoordinatorImpl) -> Void)?

	var childCoordinators = [Coordinator]()

	let baseNavController: NavController

	let navController: NavController

	let task: Task

	// MARK: - Init

	init(baseNavigation: NavController,
		 navigation: NavController,
		 editableTask: Task) {
		navController = navigation
		baseNavController = baseNavigation
		task = editableTask
	}

	// MARK: - API

	func start() {
		let editTaskVC = EditTaskViewController.controller(in: .projectDetails)
		navController.viewControllers = [editTaskVC]
		editTaskVC.onFinishAddingTaskAction = finish
		editTaskVC.onShowDatePickerAction = changeDate(from:)
		editTaskVC.onShowPrioritiesListAction = changePriority(from:)
		editTaskVC.currentTask = task
		baseNavController.present(navController, animated: true, completion: nil)
	}

	func finish() {
		baseNavController.dismiss(animated: true, completion: nil)
		onFinishEditingTaskAction?(self)
	}
	
}
