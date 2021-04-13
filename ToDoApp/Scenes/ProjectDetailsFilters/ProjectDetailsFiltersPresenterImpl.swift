//
//  ProjectDetailsFiltersPresenterImpl.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 17.03.2021.
//

import Foundation

// MARK: - Protocol

protocol ProjectDetailsFiltersPresenter {
	func present(sections: [ProjectDetailsFiltersSection])
}

// MARK: - Presenter

final class ProjectDetailsFiltersPresenterImpl {

	// MARK: - Properties

	private weak var view: ProjectDetailsFiltersView?

	// MARK: - Init

	init(view: ProjectDetailsFiltersView) {
		self.view = view
	}

}

// MARK: - Presentation logic

extension ProjectDetailsFiltersPresenterImpl: ProjectDetailsFiltersPresenter {
	func present(sections: [ProjectDetailsFiltersSection]) {
		view?.display(sections: sections)
	}
}
