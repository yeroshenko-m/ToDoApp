//
//  SelectTaskPriorityInteractorImpl.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 06.03.2021.
//

import Foundation

// MARK: - Protocol

protocol SelectTaskPriorityInteractor {

	func fetchPriorities()

}

// MARK: - Interactor

final class SelectTaskPriorityInteractorImpl {

	// MARK: - Properties

	private let presenter: SelectTaskPriorityPresenter
	private let priorities = Priority.allCases

	// MARK: - Init

	init(presenter: SelectTaskPriorityPresenter) {
		self.presenter = presenter
	}

}

// MARK: - Business logic

extension SelectTaskPriorityInteractorImpl: SelectTaskPriorityInteractor {

	func fetchPriorities() {
		presenter.present(priorities: priorities)
	}
	
}
