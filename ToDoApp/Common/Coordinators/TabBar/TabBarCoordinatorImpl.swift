//
//  TabBarCoordinator.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 10.03.2021.
//

import UIKit

final class TabBarCoordinatorImpl: TabBarCoordinator {

	// MARK: - Properties

	var childCoordinators: [Coordinator] = []

	let navController: NavController

	let tabBarController: MainTabBarController

	// MARK: - Init

	init(navigation: NavController,
		 tabBar: MainTabBarController) {
		navController = navigation
		tabBarController = tabBar
	}

	// MARK: - API

	func start() {
		let projectsNavController = NavController()
		let projectsListCoordinator = ProjectsListCoordinatorImpl(navigation: projectsNavController)
		projectsNavController.tabBarItem = UITabBarItem(title: R.string.localizable.tabBarController_projectsListTitle(),
														image: R.image.folder()?.withRenderingMode(.alwaysTemplate),
														tag: 0)

		let tasksNavController = NavController()
		let tasksListCoordinator = TasksListCoordinatorImpl(navigation: tasksNavController)
		tasksNavController.tabBarItem = UITabBarItem(title: R.string.localizable.tabBarController_tasksListTitle(),
													 image: R.image.stackFill()?.withRenderingMode(.alwaysTemplate),
													 tag: 1)

		let settingsNavController = NavController()
		let settingsCoordinator = SettingsCoordinatorImpl(navigation: settingsNavController)
		settingsNavController.tabBarItem = UITabBarItem(title: R.string.localizable.tabBarController_settingsTitle(),
														image: R.image.gearFill()?.withRenderingMode(.alwaysTemplate),
														tag: 2)
		settingsCoordinator.onReloginAction = { navController in
			self.showReloginFlow(on: navController)
		}

		tabBarController.viewControllers = [projectsNavController, tasksNavController, settingsNavController]

		projectsListCoordinator.start()
		tasksListCoordinator.start()
		settingsCoordinator.start()
	}

	func showReloginFlow(on navigation: NavController) {
		let authCoordinator = AuthCoordinatorImpl(style: .reLogin, navigation: navigation)
		authCoordinator.onAuthSuccess = { coordinator in
			for (index, child) in self.childCoordinators.enumerated() where child === coordinator {
				self.childCoordinators.remove(at: index)
			}
			self.tabBarController.viewControllers?.forEach { ($0 as? NavController)?.popToRootViewController(animated: true) }
			self.tabBarController.selectedIndex = .zero
		}
		childCoordinators.append(authCoordinator)
		authCoordinator.start()
	}

}
