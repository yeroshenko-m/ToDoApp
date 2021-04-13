//
//  ProjectsListPresenter.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 05.03.2021.
//

import Foundation

// MARK: - Protocol

protocol ProjectsListPresenter {
	func present(result: Result<[Project], Error>)
	func presentSearch(result: Result<[Project], Error>)
	func presentOfflineError(_ error: ReachabilityError, message: String)
	func presentFetchingSuccess()
}

// MARK: - Presenter

final class ProjectsListPresenterImpl {

	// MARK: - Properties

	private weak var view: ProjectsListView?

	// MARK: - Init

	init(view: ProjectsListView) {
		self.view = view
	}

}

// MARK: - Presentation logic

extension ProjectsListPresenterImpl: ProjectsListPresenter {

	func present(result: Result<[Project], Error>) {
		switch result {
		case .failure(let error):
			view?.endRefreshing()
			view?.display(error: error)
		case .success(let projects):
			view?.display(projectsList: projects)
		}
	}

	func presentSearch(result: Result<[Project], Error>) {
		switch result {
		case .failure(let error):
			view?.endRefreshing()
			view?.display(error: error)
		case .success(let projects):
			view?.displaySearch(projectsList: projects)
		}
	}

	func presentFetchingSuccess() {
		view?.endRefreshing()
	}

	func presentOfflineError(_ error: ReachabilityError, message: String) {
		view?.display(error: error,
					  message: message,
					  dismissButtonTitle: R.string.localizable.editProjectScreen_alertOk(),
					  dismissHandler: nil)
		view?.endRefreshing()
	}

}
