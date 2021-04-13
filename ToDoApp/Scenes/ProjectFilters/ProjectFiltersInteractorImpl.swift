//
//  ProjectFiltersInteractor.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 16.03.2021.
//

import Foundation

// MARK: - Protocol

protocol ProjectFiltersInteractor {
	func fetchSections()
}

// MARK: - Interactor

final class ProjectFiltersInteractorImpl {

	// MARK: - Properties

	private let presenter: ProjectFiltersPresenter

	// MARK: - Init

	init(presenter: ProjectFiltersPresenter) {
		self.presenter = presenter
	}

}

// MARK: - Business logic

extension ProjectFiltersInteractorImpl: ProjectFiltersInteractor {

	func fetchSections() {
		presenter.present(sections: [
			.init(type: .byFavorite, items: [.init(sortDescriptor: .favoriteFirst,
												   image: R.image.bookmark1()!.withRenderingMode(.alwaysTemplate)),
											 .init(sortDescriptor: .favoriteLast,
												   image: R.image.bookmarkFill1()!.withRenderingMode(.alwaysTemplate))])
		])
	}
	
}
