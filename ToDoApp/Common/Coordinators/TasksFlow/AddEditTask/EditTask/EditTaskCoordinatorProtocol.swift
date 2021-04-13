//
//  EditTaskCoordinatorProtocol.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 04.04.2021.
//

import Foundation

protocol EditTaskCoordinator: AddEditTaskCoordinator {
	var task: Task { get }
	var onFinishEditingTaskAction: ((EditTaskCoordinatorImpl) -> Void)? { get set }
}
