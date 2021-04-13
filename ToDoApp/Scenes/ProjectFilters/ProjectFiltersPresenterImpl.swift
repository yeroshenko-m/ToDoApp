//
//  ProjectFiltersPresenter.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 16.03.2021.
//

import Foundation

// MARK: - Protocol

protocol ProjectFiltersPresenter {
	func present(sections: [ProjectFiltersSection])
}

// MARK: - Presenter

final class ProjectFiltersPresenterImpl {

	// MARK: - Properties

	private weak var view: ProjectFiltersView?

	// MARK: - Init

	init(view: ProjectFiltersView) {
		self.view = view
	}
	
}

// MARK: - Presentation logic

extension ProjectFiltersPresenterImpl: ProjectFiltersPresenter {
	func present(sections: [ProjectFiltersSection]) {
		view?.display(sections: sections)
	}
}
