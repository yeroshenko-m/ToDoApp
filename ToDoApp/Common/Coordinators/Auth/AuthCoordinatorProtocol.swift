//
//  AuthCoordinatorProtocol.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 04.04.2021.
//

import Foundation

protocol AuthCoordinator: Coordinator {
	var onAuthSuccess: ((AuthCoordinator) -> Void)? { get set }
	func finish()
}
