//
//  ProjectDetailsFiltersInteractorImpl.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 17.03.2021.
//

import Foundation

// MARK: - Protocol

protocol ProjectDetailsFiltersInteractor {
	func fetchSections()
}

// MARK: - Interactor

final class ProjectDetailsFiltersInteractorImpl {

	// MARK: - Properties

	private let presenter: ProjectDetailsFiltersPresenter

	// MARK: - Init

	init(presenter: ProjectDetailsFiltersPresenter) {
		self.presenter = presenter
	}

}

// MARK: - Business logic

extension ProjectDetailsFiltersInteractorImpl: ProjectDetailsFiltersInteractor {
	
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
