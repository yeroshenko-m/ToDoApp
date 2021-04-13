//
//  CoordinatorProtocol.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 10.03.2021.
//

import Foundation

// MARK: - Protocol

protocol Coordinator: class {
	var navController: NavController { get }
	var childCoordinators: [Coordinator] { get set }
	var reachabilityManager: ReachabilityManager { get }

	func start()
	func childDidFinish(_ child: Coordinator?)
}

extension Coordinator {

	var reachabilityManager: ReachabilityManager {
		ReachabilityManager.shared
	}

	func removeChild(coordinator: Coordinator) {
		for (index, child) in childCoordinators.enumerated() where child === coordinator {
			childCoordinators.remove(at: index)
		}
	}

	func childDidFinish(_ child: Coordinator?) {
		for (index, coordinator) in childCoordinators.enumerated() where coordinator === child {
			childCoordinators.remove(at: index)
		}
	}

	func isUnreachable(errorMessage: String) -> Bool {
		if reachabilityManager.isUnreachable {
			(navController.viewControllers.last as? BaseViewController)?
				.displayAlert(withTitle: R.string.localizable.reachability_offlineTitle(),
							  alertMessage: errorMessage,
							  actionButtonTitle: R.string.localizable.editTaskScreen_alertOk(),
							  action: nil)
			return true
		} else {
			return false
		}
	}
	
}
