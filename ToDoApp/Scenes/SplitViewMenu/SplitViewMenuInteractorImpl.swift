//
//  SplitMenuInteractorImpl.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 06.04.2021.
//

import Foundation

// MARK: - Protocol

protocol SplitMenuInteractor {
	func fetchSections()
}

// MARK: - Interactor

final class SplitMenuInteractorImpl {

	// MARK: - Properties

	private let presenter: SplitMenuPresenter

	// MARK: - Init

	init(presenter: SplitMenuPresenter) {
		self.presenter = presenter
	}

}

// MARK: - Business logic

extension SplitMenuInteractorImpl: SplitMenuInteractor {

	func fetchSections() {
		presenter.present(sections: SplitMenuScreenSections.allCases)
	}
}
