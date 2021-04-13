//
//  MainSplitCoordinatorProtocol.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 07.04.2021.
//

import UIKit

protocol MainSplitCoordinator: Coordinator {
	var window: UIWindow? { get set }
	var splitViewController: UISplitViewController { get }
	func showAllProjects()
	func showAllTasks()
	func showSettings()
	func showReloginFlow()
}
