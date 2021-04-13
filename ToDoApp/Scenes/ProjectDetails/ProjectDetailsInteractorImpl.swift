//
//  ProjectDetailsInteractorImpl.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 07.03.2021.
//

import Foundation

// MARK: - Protocol

protocol ProjectDetailsInteractor {
	var project: Project? { get set }
	var tasksOrderStorage: TasksOrderStorage { get set }

	func fetchTasks(for project: Project)
	func delete(task: Task)
	func close(task: Task)
	func searchTask(by phrase: String, for project: Project)
}

// MARK: - Interactor

final class ProjectDetailsInteractorImpl {

	// MARK: - Properties

	private let presenter: ProjectDetailsPresenter
	private let projectsService: ProjectsService
	private let tasksService: TasksService
	private let reachabilityManager: ReachabilityManager

	private var debounceSearchProjectWorkItem: DispatchWorkItem?
	private var debounceCloseProjectWorkItem: DispatchWorkItem?

	var tasksOrderStorage = TasksOrderStorage()
	var project: Project?

	// MARK: - Init

	init(presenter: ProjectDetailsPresenter,
		 projectsService: ProjectsService,
		 tasksService: TasksService) {
		self.presenter = presenter
		self.projectsService = projectsService
		self.tasksService = tasksService
		reachabilityManager = ReachabilityManager.shared
		self.projectsService.addDelegate(self)
		self.tasksService.addDelegate(self)
	}

	// MARK: - Deinit

	deinit {
		projectsService.removeDelegate(self)
		tasksService.removeDelegate(self)
	}

}

// MARK: - Business logic

extension ProjectDetailsInteractorImpl: ProjectDetailsInteractor {

	// TODO: Fix double network fetching
	func fetchTasks(for project: Project) {
		guard reachabilityManager.isReachable else {
			fetchCachedTasksFor(project)
			return
		}

		fetchCachedTasksFor(project, completion: { project in
			self.tasksService.fetchTasksForProject(project) { fetchingResult in
				self.handle(result: fetchingResult)
			}
		})

	}

	func delete(task: Task) {
		guard reachabilityManager.isReachable else {
			presenter.presentOfflineError(.deviceOffline,
										  message: R.string.localizable.reachability_deleteTask())
			return
		}

		tasksService.deleteTask(task) { deletionResult in
			self.handle(result: deletionResult)
		}
	}

	func close(task: Task) {
		guard reachabilityManager.isReachable else {
			presenter.presentOfflineError(.deviceOffline,
										  message: R.string.localizable.reachability_closeTask())
			return
		}
		
		if debounceCloseProjectWorkItem != nil {
			debounceCloseProjectWorkItem?.cancel()
			debounceCloseProjectWorkItem = nil
		} else {
			let newWorkItem = DispatchWorkItem { [weak self] in
				self?.tasksService.closeTask(task) { closingResult in
					self?.handle(result: closingResult)
				}
			}

			Timer.scheduledTimer(withTimeInterval: 2.5, repeats: false) { _ in
				DispatchQueue.main.async(execute: newWorkItem)
			}

			debounceCloseProjectWorkItem = newWorkItem
		}
	}
	
	func searchTask(by phrase: String, for project: Project) {
		debounceSearchProjectWorkItem?.cancel()
		let newSearchItem = DispatchWorkItem { [weak self] in
			let predicate = TaskFilteringPredicates.taskNameContains(phrase: phrase,
																	 projectId: project.id)
			self?.tasksService.fetchCachedTasks(withPredicate: predicate,
												sortedBy: [.dateAscending, .nameAZ]) { fetchingResult in
				self?.presenter.presentSearch(result: fetchingResult)
			}
		}
		
		Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
			DispatchQueue.main.async(execute: newSearchItem)
		}
		
		debounceSearchProjectWorkItem = newSearchItem
	}

	// MARK: - Private implementation

	private func handle(result: Result<Void, Error>) {
		switch result {
		case .failure(let error):
			presenter.present(result: .failure(error))
		case .success:
			presenter.presentFetchingSuccess()
		}
	}

	private func fetchCachedTasksFor(_ project: Project,
									 completion: ((Project) -> Void)? = nil) {
		let predicate = TaskFilteringPredicates.hasRelatedProject(project.id)
		var sortDescriptors = tasksOrderStorage.allSortDescriptors()
		sortDescriptors.append(.nameAZ)
		tasksService.fetchCachedTasks(withPredicate: predicate,
									  sortedBy: sortDescriptors) { fetchingResult in
			self.presenter.present(result: fetchingResult)
		}
		completion?(project)
	}
	
}

// MARK: - TasksServiceDelegate

extension ProjectDetailsInteractorImpl: TasksServiceDelegate,
										ProjectsServiceDelegate {

	func onStorageChange() {
		guard let project = project else { return  }
		fetchCachedTasksFor(project)
	}

}
