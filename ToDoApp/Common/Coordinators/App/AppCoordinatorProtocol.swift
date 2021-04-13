//
//  AppCoordinatorProtocol.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 04.04.2021.
//

import UIKit

protocol AppCoordinator: Coordinator {
	var window: UIWindow? { get set }
	func showLoginFlow()
	func showMainFlow()
}
