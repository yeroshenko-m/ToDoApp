//
//  AddTaskCoordinatorProtocol.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 04.04.2021.
//

import Foundation

protocol AddTaskCoordinator: AddEditTaskCoordinator {
	var project: Project? { get }
	var onFinishAddingTask: ((AddTaskCoordinatorImpl) -> Void)? { get set }
	func changeProject(from currentProject: Project?)
	func projectChanged(to newProject: Project)
}
