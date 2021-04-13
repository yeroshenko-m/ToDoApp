//
//  SettingsCoordinator.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 12.03.2021.
//

import Foundation

final class SettingsCoordinatorImpl: SettingsCoordinator {

	// MARK: - Properties

	var onReloginAction: ((NavController) -> Void)?

	var childCoordinators = [Coordinator]()
	
	let navController: NavController

	// MARK: - Init

	init(navigation: NavController) {
		navController = navigation
	}

	// MARK: - API

	func start() {
		let settingsVC = SettingsViewController.controller(in: .settings)
		settingsVC.onLogoutOccured = {
			self.showLoginFlow()
		}
		navController.show(settingsVC, sender: nil)
	}

	func showLoginFlow() {
		onReloginAction?(navController)
	}

}
