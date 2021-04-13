//
//  TasksListCoordinator.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 11.03.2021.
//

import Foundation

final class TasksListCoordinatorImpl: TasksListCoordinator {

	// MARK: - Properties

	var childCoordinators = [Coordinator]()

	let navController: NavController

	// MARK: - Init

	init(navigation: NavController) {
		navController = navigation
	}

	// MARK: - API

	func start() {
		let tasksListVC = TasksListViewController.controller(in: .taskslist)
		tasksListVC.onAddTaskAction = showAddTask
		tasksListVC.onEditTaskAction = showEditTask(_:)
		tasksListVC.onChangeListOrderAction = changeTasksOrder(in:)
		tasksListVC.onShowCellPreviewAction = { task in
			let editTaskVC = EditTaskViewController.controller(in: .projectDetails)
			editTaskVC.currentTask = task
			return editTaskVC
		}
		navController.show(tasksListVC, sender: nil)
	}

	// MARK: - Add/Edit

	func showEditTask(_ task: Task) {
		if isUnreachable(errorMessage: R.string.localizable.reachability_editTask()) {
			return
		}

		let navigation = NavController()
		let editTaskCoordinator = EditTaskCoordinatorImpl(baseNavigation: navController,
														  navigation: navigation,
														  editableTask: task)
		editTaskCoordinator.onFinishEditingTaskAction = removeChild(coordinator:)
		childCoordinators.append(editTaskCoordinator)
		editTaskCoordinator.start()

	}

	func showAddTask() {
		if isUnreachable(errorMessage: R.string.localizable.reachability_addTask()) {
			return
		}

		let navigation = NavController()
		let addTaskCoordinator = AddTaskCoordinatorImpl(baseNavigation: navController,
														navigation: navigation)
		addTaskCoordinator.onFinishAddingTask = removeChild(coordinator:)
		childCoordinators.append(addTaskCoordinator)
		addTaskCoordinator.start()
	}

	// MARK: - Ordering tasks

	func changeTasksOrder(in orderStorage: TasksOrderStorage) {
		let navigation = NavController()
		let tasksFiltersListVC = TasksListFiltersViewController.controller(in: .taskslist)
		tasksFiltersListVC.onOrderChangedAction = tasksOrderChanged
		tasksFiltersListVC.setSelectedOrder(orderStorage)
		navigation.viewControllers = [tasksFiltersListVC]
		navController.present(navigation, animated: true, completion: nil)
	}

	func tasksOrderChanged() {
		navController.viewControllers.forEach {
			($0 as? TasksListViewController)?.refreshTasksList()
		}
		navController.dismiss(animated: true, completion: nil)
	}

}
