//
//  EditProjectCoordinatorProtocol.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 04.04.2021.
//

import Foundation

protocol EditProjectCoordinator: AddEditProjectCoordinator {
	var project: Project { get }
	var onFinishEditingActionOccured: ((EditProjectCoordinatorImpl) -> Void)? { get set }
}
