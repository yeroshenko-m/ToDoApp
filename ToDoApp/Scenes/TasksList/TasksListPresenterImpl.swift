//
//  TasksListPresenterImpl.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 09.03.2021.
//

import Foundation

// MARK: - Protocol

protocol TasksListPresenter {
	func present(result: Result<[Task], Error>)
	func presentSearch(result: Result<[Task], Error>)
	func presentFetchingSuccess()
	func presentOfflineError(_ error: ReachabilityError, message: String)
}

// MARK: - Presenter

final class TasksListPresenterImpl {

	// MARK: - Properties

	private weak var view: TasksListView?

	// MARK: - Init

	init(view: TasksListView) {
		self.view = view
	}

}

// MARK: - Presentation logic

extension TasksListPresenterImpl: TasksListPresenter {

	func present(result: Result<[Task], Error>) {
		switch result {
		case .failure(let error):
			view?.display(error: error)
			view?.endRefreshing()
		case .success(let tasks):
			let sections = TasksSectionsMapper.mapToSectionsByProject(tasks: tasks)
			view?.display(tasks: sections)
		}
	}

	func presentSearch(result: Result<[Task], Error>) {
		switch result {
		case .failure(let error):
			view?.endRefreshing()
			view?.display(error: error)
		case .success(let tasks):
			let sections = TasksSectionsMapper.mapToSectionsByProject(tasks: tasks)
			view?.displaySearch(tasks: sections)
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
