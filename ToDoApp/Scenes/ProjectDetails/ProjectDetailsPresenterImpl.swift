//
//  ProjectDetailsPresenterImpl.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 07.03.2021.
//

import Foundation

// MARK: - Protocol

protocol ProjectDetailsPresenter {
	func present(result: Result<[Task], Error>)
	func presentSearch(result: Result<[Task], Error>)
	func presentFetchingSuccess()
	func presentOfflineError(_ error: ReachabilityError, message: String)
}

// MARK: - Presenter

final class ProjectDetailsPresenterImpl {

	// MARK: - Properties

	private weak var view: ProjectDetailsView?

	// MARK: - Init

	init(view: ProjectDetailsView) {
		self.view = view
	}

}

// MARK: - Presentation logic

extension ProjectDetailsPresenterImpl: ProjectDetailsPresenter {

	func present(result: Result<[Task], Error>) {
		switch result {
		case .failure(let error):
			view?.display(error: error)
			view?.endRefreshing()
		case .success(let tasks):
			view?.display(tasks: tasks)
		}
	}

	func presentSearch(result: Result<[Task], Error>) {
		switch result {
		case .failure(let error):
			view?.endRefreshing()
			view?.display(error: error)
		case .success(let tasks):
			view?.displaySearch(tasks: tasks)
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
