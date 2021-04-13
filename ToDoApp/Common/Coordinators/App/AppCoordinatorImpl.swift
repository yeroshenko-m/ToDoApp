//
//  AppCoordinator.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 10.03.2021.
//

import UIKit

final class AppCoordinatorImpl: AppCoordinator {

	// MARK: - Properties

	var window: UIWindow?

	var childCoordinators = [Coordinator]()

	let navController: NavController

	private let authService: AuthService

	// MARK: - Init

	init(appWindow: UIWindow?,
		 navigation: NavController,
		 appAuthService: AuthService) {
		window = appWindow
		navController = navigation
		authService = appAuthService
	}

	// MARK: - API

	func start() {
		authService.isAuthorized ? showMainFlow() : showLoginFlow()
	}

	func showLoginFlow() {
		let authCoordinator = AuthCoordinatorImpl(style: .login,
												  navigation: navController)
		authCoordinator.onAuthSuccess = { child in
			self.childDidFinish(child)
		}
		childCoordinators.append(authCoordinator)
		window?.rootViewController = navController
		authCoordinator.start()
	}

	func showMainFlow() {
		switch SystemHelper.currentDeviceType {
		case .mac:
			startAdaptedFlow()
		default:
			startMobileFlow()
		}
	}

	func childDidFinish(_ child: Coordinator?) {
		for (index, coordinator) in childCoordinators.enumerated() where coordinator === child {
			childCoordinators.remove(at: index)
		}

		if child is AuthCoordinator {
			showMainFlow()
		}
	}

	// MARK: - Private implementation

	private func startAdaptedFlow() {
		let splitViewController = SplitViewController(style: .doubleColumn)
		let splitCoordinator = MacSplitCoordinatorImpl(split: splitViewController,
														rootWindow: window)
		childCoordinators.append(splitCoordinator)
		window?.rootViewController = splitViewController
		splitCoordinator.start()
	}

	private func startMobileFlow() {
		let tabBar = MainTabBarController()
		let tabBarCoordinator = TabBarCoordinatorImpl(navigation: navController,
													  tabBar: tabBar)
		childCoordinators.append(tabBarCoordinator)
		window?.rootViewController = tabBar
		tabBarCoordinator.start()
	}

}
