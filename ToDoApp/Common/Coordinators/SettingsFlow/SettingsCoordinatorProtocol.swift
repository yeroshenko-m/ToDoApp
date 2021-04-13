//
//  SettingsCoordinatorProtocol.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 04.04.2021.
//

import Foundation

protocol SettingsCoordinator: Coordinator {
	var onReloginAction: ((NavController) -> Void)? { get set }
	func showLoginFlow()
}
