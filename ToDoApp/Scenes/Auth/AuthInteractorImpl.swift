//
//  AuthInteractor.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 04.03.2021.
//

import WebKit

// MARK: - Protocol

protocol AuthInteractor {
	func loadAuthURL()
	func fetchToken(url: URL)
	func clearWebCache()
}

// MARK: - Interactor

final class AuthInteractorImpl {

	// MARK: - Properties

	private let presenter: AuthPresenter
	private let authService: AuthService

	// MARK: - Init

	init(authService: AuthService,
		 presenter: AuthPresenter) {
		self.authService = authService
		self.presenter = presenter
	}

}

// MARK: - Business logic

extension AuthInteractorImpl: AuthInteractor {

	func loadAuthURL() {
		guard
			let authURL = authService.codeRequestURL
		else {
			presenter.presentAuthPageLoadingResult(.failure(AuthSceneError.badAuthURL))
			return
		}
		presenter.presentAuthPageLoadingResult(.success(authURL))
	}

	func fetchToken(url: URL) {
		if authService.isRedirectURLValid(url),
		   let code = authService.fetchCodeFromURL(url) {
			authService.fetchToken(withCode: code) { [weak self] result in
				guard let self = self else { return }
				switch result {
				case .failure(let error):
					self.presenter.presentFetchingTokenResult(.failure(error))
				case .success:
					self.presenter.presentFetchingTokenResult(.success(()))
				}
			}
		}
	}

	func clearWebCache() {
		let dataStore = WKWebsiteDataStore.default()
		dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
			dataStore.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(),
								 for: records) {
			}
		}
	}

}

enum AuthSceneError: Error {
	case badAuthURL
}

extension AuthSceneError {
	var localizedDescription: String {
		switch self {
		case .badAuthURL:
			return "Failed loading login page. Try later"
		}
	}
}
