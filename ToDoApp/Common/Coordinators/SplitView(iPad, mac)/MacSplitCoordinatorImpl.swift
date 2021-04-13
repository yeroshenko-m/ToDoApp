//
//  MainSplitViewController.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 06.04.2021.
//

import UIKit

final class MacSplitCoordinatorImpl: MainSplitCoordinator {

	let navController: NavController
	var childCoordinators: [Coordinator] = []
	var window: UIWindow?
	let splitViewController: UISplitViewController

	// MARK: - Init

	init(split: UISplitViewController,
		 rootWindow: UIWindow?) {
 		splitViewController = split
		window = rootWindow
		navController = NavController()
	}

	// MARK: - API

	func start() {
		let splitMenuController = SplitMenuViewController.controller(in: .splitmenu)
		let splitNavigation = NavController(rootViewController: splitMenuController)
		splitMenuController.onAllProjectsSectionTapAction = showAllProjects
		splitMenuController.onAllTasksSectionTapAction = showAllTasks
		splitMenuController.onSettingsSectionTapAction = showSettings
		splitViewController.setViewController(splitNavigation, for: .primary)
		showAllProjects()
	}

	func showAllProjects() {
		let navigation = NavController()
		splitViewController.setViewController(navigation, for: .secondary)
		let projectsCoordinator = ProjectsListCoordinatorImpl(navigation: navigation)
		projectsCoordinator.start()
	}

	func showAllTasks() {
		let navigation = NavController()
		splitViewController.setViewController(navigation, for: .secondary)
		let tasksCoordinator = TasksListCoordinatorImpl(navigation: navigation)
		tasksCoordinator.start()

	}

	func showSettings() {
		let navigation = NavController()
		splitViewController.setViewController(navigation, for: .secondary)
		let settingsCoordinator = SettingsCoordinatorImpl(navigation: navigation)
		settingsCoordinator.onReloginAction = { _ in
			self.showReloginFlow()
		}
		settingsCoordinator.start()
	}

	func showReloginFlow() {
		let navigation = NavController()
		let authCoordinator = AuthCoordinatorImpl(style: .login,
												  navigation: navigation)
		window?.rootViewController = navigation
		authCoordinator.onAuthSuccess = { _ in
			self.window?.rootViewController = self.splitViewController
			self.start()
		}
		authCoordinator.start()
	}

}
