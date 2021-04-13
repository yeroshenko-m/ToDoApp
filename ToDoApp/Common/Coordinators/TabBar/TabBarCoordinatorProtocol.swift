//
//  TabBarCoordinatorProtocol.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 04.04.2021.
//

import Foundation

protocol TabBarCoordinator: Coordinator {
	var tabBarController: MainTabBarController { get }
	func showReloginFlow(on navigation: NavController)
}
