//
//  MainCoordinator.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 10.03.2021.
//

import UIKit

final class ProjectsListCoordinatorImpl: ProjectsListCoordinator {
	
	// MARK: - Properties

	var childCoordinators = [Coordinator]()

	let navController: NavController

	// MARK: - Init

	init(navigation: NavController) {
		navController = navigation
	}

	// MARK: - API

	func start() {
		let projectsListVC = ProjectsListViewController.controller(in: .projectsList)
		projectsListVC.onShowCellPreviewAction = { project -> UIViewController? in
			let projectDetailsVC = ProjectDetailsViewController.controller(in: .projectDetails)
			projectDetailsVC.currentProject = project
			return projectDetailsVC
		}
		projectsListVC.onAddProjectAction = showAddProject
		projectsListVC.onEditProjectAction = showEdit(project:)
		projectsListVC.onShowProjectDetailsAction = showDetailsFor(project:)
		projectsListVC.onChangeListOrderAction = changeProjectsOrder(in:)
		navController.show(projectsListVC, sender: nil)
	}

	func showDetailsFor(project: Project) {
		let projectDetailsVC = ProjectDetailsViewController.controller(in: .projectDetails)
		projectDetailsVC.currentProject = project
		projectDetailsVC.onAddTaskAction = showAddTask(for:)
		projectDetailsVC.onEditTaskAction = showEdit(task:)
		projectDetailsVC.onChangeListOrderAction = changeTasksOrder(in:)
		projectDetailsVC.onShowCellPreviewAction = { task in
			let editTaskVC = EditTaskViewController.controller(in: .projectDetails)
			editTaskVC.currentTask = task
			return editTaskVC
		}
		navController.show(projectDetailsVC, sender: nil)
	}

	// MARK: - Add/edit project

	func showEdit(project: Project) {
		if isUnreachable(errorMessage: R.string.localizable.reachability_editProject()) {
			return
		}

		let navigation = NavController()
		let editProjectCoordinator = EditProjectCoordinatorImpl(baseNavigation: navController,
																navigation: navigation,
																editableProject: project)
		editProjectCoordinator.onFinishEditingActionOccured = removeChild(coordinator:)
		childCoordinators.append(editProjectCoordinator)
		editProjectCoordinator.start()
	}

	func showAddProject() {
		if isUnreachable(errorMessage: R.string.localizable.reachability_addProject()) {
			return
		}

		let navigation = NavController()
		let addProjectCoordinator = AddProjectCoordinatorImpl(baseNavigation: navController,
															  navigation: navigation)
		addProjectCoordinator.onFinishAddingProjectAction = removeChild(coordinator:)
		childCoordinators.append(addProjectCoordinator)
		addProjectCoordinator.start()
	}

	// MARK: - Add/edit task

	func showEdit(task: Task) {
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

	func showAddTask(for project: Project) {
		if isUnreachable(errorMessage: R.string.localizable.reachability_addTask()) {
			return
		}

		let navigation = NavController()
		let addTaskCoordinator = AddTaskCoordinatorImpl(baseNavigation: navController,
														navigation: navigation,
														selectedProject: project)
		addTaskCoordinator.onFinishAddingTask = removeChild(coordinator:)
		childCoordinators.append(addTaskCoordinator)
		addTaskCoordinator.start()
	}

	// MARK: - Ordering projects

	func changeProjectsOrder(in orderStorage: ProjectsOrderStorage) {
		let navigation = NavController()
		let projectFiltersVC = ProjectFiltersViewController.controller(in: .projectsList)
		projectFiltersVC.onOrderChangeAction = self.projectOrderChanged
		projectFiltersVC.setSelectedOrder(orderStorage)
		navigation.viewControllers = [projectFiltersVC]
		navController.present(navigation, animated: true, completion: nil)
	}

	func projectOrderChanged() {
		navController.viewControllers.forEach {
			($0 as? ProjectsListViewController)?.refreshProjectsList()
		}
		navController.dismiss(animated: true, completion: nil)
	}

	// MARK: - Ordering tasks

	func changeTasksOrder(in orderStorage: TasksOrderStorage) {
		let navigation = NavController()
		let projectDetailsFiltersVC = ProjectDetailsFiltersViewController.controller(in: .projectDetails)
		projectDetailsFiltersVC.onOrderChangeAction = tasksOrderChanged
		projectDetailsFiltersVC.setSelectedOrder(orderStorage)
		navigation.viewControllers = [projectDetailsFiltersVC]
		navController.present(navigation, animated: true, completion: nil)
	}

	func tasksOrderChanged() {
		navController.viewControllers.forEach {
			($0 as? ProjectDetailsViewController)?.refreshProjectTasks()
		}
		navController.dismiss(animated: true, completion: nil)
	}

}
