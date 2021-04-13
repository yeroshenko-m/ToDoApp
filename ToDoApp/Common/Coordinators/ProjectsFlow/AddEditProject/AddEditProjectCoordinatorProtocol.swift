//
//  EditProjectCoordinatorProtocol.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 04.04.2021.
//

import Foundation

protocol AddEditProjectCoordinator: Coordinator {
	func finish()
	func changeColorId(currentId colorId: Int)
	func colorChanged(_ colorId: Int?)
}

extension AddEditProjectCoordinator {

	func changeColorId(currentId colorId: Int) {
		let selectColorVC = SelectProjectColorViewController.controller(in: .projectsList)
		selectColorVC.onColorChangedAction = colorChanged(_:)
		selectColorVC.currentColorId = colorId
		navController.show(selectColorVC, sender: nil)
	}

	func colorChanged(_ colorId: Int?) {
		navController.viewControllers.forEach {
			($0 as? UpdatableWithProjectInfo)?.setColor(id: colorId ?? TodoistColor.defaultColor.id)
		}
		navController.popViewController(animated: true)
	}
	
}
