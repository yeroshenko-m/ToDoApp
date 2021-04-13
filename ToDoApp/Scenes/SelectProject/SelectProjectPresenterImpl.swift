//
//  SelectProjectPresenterImpl.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 06.03.2021.
//

import Foundation

// MARK: - Protocol

protocol SelectProjectPresenter {
	func present(result: Result<[Project], Error>)
}

// MARK: - Presenter

final class SelectProjectPresenterImpl {

	// MARK: - Properties

	private weak var view: SelectProjectView?

	// MARK: - Init

	init(view: SelectProjectView) {
		self.view = view
	}

}

// MARK: - Presentation logic

extension SelectProjectPresenterImpl: SelectProjectPresenter {

	func present(result: Result<[Project], Error>) {
		switch result {
		case .failure(let error):
			view?.display(error: error)
		case .success(let projects):
			view?.display(projectsList: projects)
		}
	}

}
