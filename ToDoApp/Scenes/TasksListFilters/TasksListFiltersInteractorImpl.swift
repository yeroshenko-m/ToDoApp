//
//  TasksListFiltersInteractorImpl.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 18.03.2021.
//

import Foundation

// MARK: - Protocol

protocol TasksListFiltersInteractor {
	func fetchSections()
}

// MARK: - Interactor

final class TasksListFiltersInteractorImpl {

	// MARK: - Properties

	private let presenter: TasksListFiltersPresenter

	// MARK: - Init

	init(presenter: TasksListFiltersPresenter) {
		self.presenter = presenter
	}

}

// MARK: - Business logic

extension TasksListFiltersInteractorImpl: TasksListFiltersInteractor {

	func fetchSections() {
		presenter.present(sections: [
			.init(type: .byDate, items: [.init(sortDescriptor: .dateAscending,
											   image: R.image.byDateAZ()!.withRenderingMode(.alwaysTemplate)),
										 .init(sortDescriptor: .dateDescending,
											   image: R.image.byDateZA()!.withRenderingMode(.alwaysTemplate))]),
			.init(type: .byCreationTime, items: [.init(sortDescriptor: .createdAscending,
													   image: R.image.byCreationAZ()!.withRenderingMode(.alwaysTemplate)),
												 .init(sortDescriptor: .createdDescending,
													   image: R.image.byCreationZA()!.withRenderingMode(.alwaysTemplate))]),
			.init(type: .byPriority, items: [.init(sortDescriptor: .priorityAscending,
												   image: R.image.byPriorityAZ()!.withRenderingMode(.alwaysTemplate)),
											 .init(sortDescriptor: .priorityDescending,
												   image: R.image.byPriorityZA()!.withRenderingMode(.alwaysTemplate))])
		])
	}

}
