//
//  SelectProjectInteractorImpl.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 06.03.2021.
//

import Foundation

// MARK: - Protocol

protocol SelectProjectInteractor {
	func fetchProjects()
}

// MARK: - Interactor

final class SelectProjectInteractorImpl {

	// MARK: - Properties

	private let presenter: SelectProjectPresenter
	private let projectsService: ProjectsService

	// MARK: - Init

	init(projectsService: ProjectsService,
		 presenter: SelectProjectPresenter) {
		self.projectsService = projectsService
		self.presenter = presenter
	}

}

// MARK: - Business logic

extension SelectProjectInteractorImpl: SelectProjectInteractor {

	func fetchProjects() {
		projectsService.fetchCachedProjects(sortedBy: [.favoriteFirst, .nameAZ]) {  [weak self] result in
			guard let self = self else { return }
			self.presenter.present(result: result)
		}
	}

}
