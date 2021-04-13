//
//  AuthCoordinator.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 10.03.2021.
//

import UIKit

final class AuthCoordinatorImpl: AuthCoordinator {

	// MARK: - Properties

	var onAuthSuccess: ((AuthCoordinator) -> Void)?

	var childCoordinators: [Coordinator] = []

	let navController: NavController

	var coordinatorStyle: AuthCoordinatorType

	// MARK: - Init

	init(style: AuthCoordinatorType,
		 navigation: NavController) {
		navController = navigation
		coordinatorStyle = style
	}

	// MARK: - API

	func start() {
		let authVC = AuthViewController.controller(in: .auth)
		authVC.onAuthSuccess = {
			self.finish()
		}
		switch coordinatorStyle {
		case .login:
			navController.navigationItem.hidesBackButton = true
			navController.viewControllers = [authVC]
//			navController.pushViewController(authVC, animated: true)
		case .reLogin:
			let authNavController = NavController()
			authNavController.pushViewController(authVC, animated: true)
			authNavController.isModalInPresentation = true
			navController.present(authNavController, animated: true, completion: nil)
		}
	}

	func finish() {
		switch coordinatorStyle {
		case .login:
			onAuthSuccess?(self)
		case .reLogin:
			navController.dismiss(animated: true, completion: nil)
			onAuthSuccess?(self)
		}
	}

}
