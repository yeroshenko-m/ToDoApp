//
//  SelectTaskPriorityPresenterImpl.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 06.03.2021.
//

import Foundation

// MARK: - Protocol

protocol SelectTaskPriorityPresenter {
	func present(priorities: [Priority])
}

// MARK: - Presenter

final class SelectTaskPriorityPresenterImpl {

	// MARK: - Properties

	private weak var view: SelectTaskPriorityView?

	// MARK: - Init

	init(view: SelectTaskPriorityView) {
		self.view = view
	}

}

// MARK: - Presentation logic

extension SelectTaskPriorityPresenterImpl: SelectTaskPriorityPresenter {

	func present(priorities: [Priority]) {
		view?.display(priorities: priorities)
	}

}
