//
//  EditProjectCoordinator.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 11.03.2021.
//

import UIKit

final class EditProjectCoordinatorImpl: EditProjectCoordinator {

	// MARK: - Properties

	var onFinishEditingActionOccured: ((EditProjectCoordinatorImpl) -> Void)?

	var childCoordinators = [Coordinator]()

	var baseNavController: NavController

	let navController: NavController

	let project: Project

	// MARK: - Init

	init(baseNavigation: NavController,
		 navigation: NavController,
		 editableProject: Project) {
		navController = navigation
		baseNavController = baseNavigation
		project = editableProject
	}

	// MARK: - API

	func start() {
		let editProjectVC = EditProjectViewController.controller(in: .projectsList)
		navController.setViewControllers([editProjectVC], animated: false)
		editProjectVC.onFinishEditingProjectAction = finish
		editProjectVC.onShowColorsListAction = changeColorId(currentId:)
		editProjectVC.currentProject = project
		baseNavController.present(navController, animated: true, completion: nil)
	}

	func finish() {
		baseNavController.dismiss(animated: true, completion: nil)
		onFinishEditingActionOccured?(self)
	}

}
