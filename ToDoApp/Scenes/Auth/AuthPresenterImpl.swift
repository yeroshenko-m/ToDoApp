//
//  LoginPresenter.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 04.03.2021.
//

import Foundation

// MARK: - Protocol

protocol AuthPresenter {
	func presentAuthPageLoadingResult(_ result: Result<URL, Error>)
	func presentFetchingTokenResult(_ result: Result<Void, Error>)
}

// MARK: - Presenter

final class AuthPresenterImpl {

	// MARK: - Properties

	private weak var view: AuthView?

	// MARK: - Init

	init(view: AuthView) {
		self.view = view
	}

}

// MARK: - Presentation logic

extension AuthPresenterImpl: AuthPresenter {

	func presentAuthPageLoadingResult(_ result: Result<URL, Error>) {
		switch result {
		case .failure(let error):
			view?.display(error: error)
		case .success(let url):
			view?.displayAuthPage(url: url)
		}
	}

	func presentFetchingTokenResult(_ result: Result<Void, Error>) {
		switch result {
		case .failure(let error):
			view?.display(error: error)
		case .success:
			view?.displayAuthSuccess()
		}
	}

}
