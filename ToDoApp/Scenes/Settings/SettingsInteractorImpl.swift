//
//  SettingsInteractorImpl.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 08.03.2021.
//

import Foundation

// MARK: - Protocol

protocol SettingsInteractor {
	func logOut()
}

// MARK: - Interactor

final class SettingsInteractorImpl {

	// MARK: - Properties

	private let presenter: SettingsPresenter
	private let authService: AuthService
	private let reachabilityManager: ReachabilityManager

	// MARK: - Init

	init(presenter: SettingsPresenter,
		 authService: AuthService) {
		self.presenter = presenter
		self.authService = authService
		reachabilityManager = ReachabilityManager.shared
	}

}

// MARK: - Business logic

extension SettingsInteractorImpl: SettingsInteractor {

	func logOut() {
		guard reachabilityManager.isReachable
		else {
			presenter.presentOfflineError(.deviceOffline)
			return
		}
		authService.logOut { result in
			self.presenter.presentLogoutResult(result)
		}
	}

}
