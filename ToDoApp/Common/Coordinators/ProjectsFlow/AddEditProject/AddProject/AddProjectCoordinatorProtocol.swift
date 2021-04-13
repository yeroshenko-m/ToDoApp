//
//  AddProjectCoordinatorProtocol.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 04.04.2021.
//

import Foundation

protocol AddProjectCoordinator: AddEditProjectCoordinator {
	var onFinishAddingProjectAction: ((AddProjectCoordinatorImpl) -> Void)? { get set }
}
