//
//  SelectProjectColorInteractorImpl.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 07.03.2021.
//

import Foundation

// MARK: - Protocol

protocol SelectProjectColorInteractor {
	func fetchColors()
}

// MARK: - Interactor

final class SelectProjectColorInteractorImpl {

	// MARK: - Properties

	private let presenter: SelectProjectColorPresenter
	private let colors = TodoistColor.allColors

	// MARK: - Init

	init(presenter: SelectProjectColorPresenter) {
		self.presenter = presenter
	}

}

// MARK: - Business logic

extension SelectProjectColorInteractorImpl: SelectProjectColorInteractor {

	func fetchColors() {
		presenter.present(colors: colors)
	}
	
}
