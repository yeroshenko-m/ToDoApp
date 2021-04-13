//
//  AddProjectCoordinator.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 11.03.2021.
//

import UIKit

final class AddProjectCoordinatorImpl: AddProjectCoordinator {

	// MARK: - Properties

	var onFinishAddingProjectAction: ((AddProjectCoordinatorImpl) -> Void)?

	var childCoordinators = [Coordinator]()

	var baseNavController: NavController

	let navController: NavController

	// MARK: - Init

	init(baseNavigation: NavController,
		 navigation: NavController) {
		navController = navigation
		baseNavController = baseNavigation
	}

	// MARK: - API

	func start() {
		let addProjectVC = AddProjectViewController.controller(in: .projectsList)
		navController.viewControllers = [addProjectVC]
		addProjectVC.onColorIdChangeAction = changeColorId(currentId:)
		addProjectVC.onFinishAddingProjectAction = finish
		baseNavController.present(navController, animated: true, completion: nil)
	}

	func finish() {
		baseNavController.dismiss(animated: true, completion: nil)
		onFinishAddingProjectAction?(self)
	}

}
