//
//  AddTaskCoordinator.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 11.03.2021.
//

import UIKit

final class AddTaskCoordinatorImpl: AddEditTaskCoordinator {

	// MARK: - Properties

	var onFinishAddingTask: ((AddTaskCoordinatorImpl) -> Void)?

	var childCoordinators = [Coordinator]()

	let baseNavController: NavController

	let navController: NavController

	let project: Project?

	// MARK: - Init

	init(baseNavigation: NavController,
		 navigation: NavController,
		 selectedProject: Project? = nil) {
		navController = navigation
		baseNavController = baseNavigation
		project = selectedProject
	}

	// MARK: - API

	func start() {
		let addTaskVC = AddTaskViewController.controller(in: .projectDetails)
		addTaskVC.currentProject = project
		navController.viewControllers = [addTaskVC]
		addTaskVC.onFinishAddingTaskAction = finish
		addTaskVC.onShowDatePickerAction = changeDate(from:)
		addTaskVC.onShowProjectsListAction = changeProject(from:)
		addTaskVC.onShowPrioritiesListAction = changePriority(from:)
		baseNavController.present(navController, animated: true, completion: nil)
	}

	func finish() {
		baseNavController.dismiss(animated: true, completion: nil)
		onFinishAddingTask?(self)
	}

	func changeProject(from currentProject: Project?) {
		let selectProjectVC = SelectProjectViewController.controller(in: .projectsList)
		selectProjectVC.onProjectSelectedAction = projectChanged(to:)
		selectProjectVC.selectedProject = currentProject
		navController.show(selectProjectVC, sender: nil)
	}

	func projectChanged(to newProject: Project) {
		navController.viewControllers.forEach {
			($0 as? UpdatableWithTaskInfo)?.setProject(newProject)
		}
		navController.popViewController(animated: true)
	}

}
