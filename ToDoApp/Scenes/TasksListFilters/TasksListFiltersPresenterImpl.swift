//
//  TasksListFiltersPresenterImpl.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 18.03.2021.
//

import Foundation

// MARK: - Protocol

protocol TasksListFiltersPresenter {
	func present(sections: [ProjectDetailsFiltersSection])
}

// MARK: - Presenter

final class TasksListFiltersPresenterImpl {

	// MARK: - Properties

	private weak var view: TasksListFiltersView?

	// MARK: - Init

	init(view: TasksListFiltersView) {
		self.view = view
	}

}

// MARK: - Presentation logic

extension TasksListFiltersPresenterImpl: TasksListFiltersPresenter {

	func present(sections: [ProjectDetailsFiltersSection]) {
		view?.display(sections: sections)
	}

}
