//
//  SettingsPresenterImpl.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 08.03.2021.
//

import UIKit

// MARK: - Protocol

protocol SettingsPresenter {
	func presentLogoutResult(_ result: Result<Void, Error>)
	func presentOfflineError(_ error: ReachabilityError)
}

// MARK: - Presenter

final class SettingsPresenterImpl {

	// MARK: - Properties

	private weak var view: SettingsView?

	init(view: SettingsView) {
		self.view = view
	}

}

// MARK: - Presentation logic

extension SettingsPresenterImpl: SettingsPresenter {

	func presentLogoutResult(_ result: Result<Void, Error>) {
		switch result {
		case .failure(let error):
			view?.display(error: error)
		case .success:
			view?.displayLogoutSuccess()
		}
	}

	func presentOfflineError(_ error: ReachabilityError) {
		view?.display(error: error,
					  message: R.string.localizable.reachability_addLogOut(),
					  dismissButtonTitle: R.string.localizable.editProjectScreen_alertOk(),
					  dismissHandler: nil)
	}

}
