//
//  TasksListInteractorImpl.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 09.03.2021.
//

import Foundation

// MARK: - Protocol

protocol TasksListInteractor {
	func fetchTasks()
	func delete(task: Task)
	func close(task: Task)
	func searchTask(by: String)

	var tasksOrderStorage: TasksOrderStorage { get set }
}

// MARK: - Interactor

final class TasksListInteractorImpl {

	// MARK: - Properties

	private let notificationCenter: NotificationCenter
	private let presenter: TasksListPresenter
	private let projectsService: ProjectsService
	private let tasksService: TasksService
	private let reachabilityManager: ReachabilityManager

	private var debounceSearchProjectWorkItem: DispatchWorkItem?
	private var debounceCloseProjectWorkItems = [Int: DispatchWorkItem?]()

	var tasksOrderStorage = TasksOrderStorage()

	// MARK: - Init

	init(presenter: TasksListPresenter,
		 projectsService: ProjectsService,
		 tasksService: TasksService) {
		self.presenter = presenter
		self.projectsService = projectsService
		self.tasksService = tasksService
		notificationCenter = NotificationCenter.default
		reachabilityManager = ReachabilityManager.shared
		self.projectsService.addDelegate(self)
		self.tasksService.addDelegate(self)
		configReachability()
	}

	// MARK: - Deinit

	deinit {
		notificationCenter.removeObserver(self,
										  name: .reachabilityChanged,
										  object: nil)
		projectsService.removeDelegate(self)
		tasksService.removeDelegate(self)
	}

}

// MARK: - Business logic

extension TasksListInteractorImpl: TasksListInteractor {

	func fetchTasks() {
		guard reachabilityManager.isReachable else {
			fetchCachedTasks()
			return
		}
		fetchCachedTasks {
			self.tasksService.fetchAll { fetchingResult in
				self.handle(result: fetchingResult)
			}
		}
	}

	func delete(task: Task) {
		guard reachabilityManager.isReachable else {
			presenter.presentOfflineError(.deviceOffline, message: R.string.localizable.reachability_deleteTask())
			return
		}

		tasksService.deleteTask(task) { deletionResult in
			self.handle(result: deletionResult)
		}
	}

	func close(task: Task) {
		guard reachabilityManager.isReachable
		else {
			presenter.presentOfflineError(.deviceOffline, message: R.string.localizable.reachability_closeTask())
			return
		}

		if let item = debounceCloseProjectWorkItems[task.id] {
			item?.cancel()
			debounceCloseProjectWorkItems.removeValue(forKey: task.id)
		} else {

			let newWorkItem = DispatchWorkItem { [weak self] in
				self?.tasksService.closeTask(task) { closingResult in
					self?.handle(result: closingResult)
				}
			}

			Timer.scheduledTimer(withTimeInterval: 2.5, repeats: false) { [weak self] _ in
				DispatchQueue.main.async(execute: newWorkItem)
				self?.debounceCloseProjectWorkItems.removeValue(forKey: task.id)
			}

			debounceCloseProjectWorkItems[task.id] = newWorkItem

		}
	}

	func searchTask(by phrase: String) {
		debounceSearchProjectWorkItem?.cancel()
		let newSearchItem = DispatchWorkItem { [weak self] in
			self?.tasksService.fetchCachedTasks(withPredicate: TaskFilteringPredicates.nameContains(phrase),
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

	private func fetchCachedTasks(completion: (() -> Void)? = nil) {
		tasksService.fetchCachedTasks(sortedBy: tasksOrderStorage.allSortDescriptors()) { [weak self] fetchingResult in
			self?.presenter.present(result: fetchingResult)
		}
		completion?()
	}

	private func configReachability() {
		notificationCenter.addObserver(self, selector: #selector(reachabilityChanged(notification:)),
									   name: .reachabilityChanged, object: nil)
	}

	// MARK: - Selectors

	@objc
	private func reachabilityChanged(notification: Notification) {
		switch reachabilityManager.connectionType {
		case .unavailable:
			return
		default:
			fetchTasks()
		}
	}
	
}

// MARK: - TasksServiceDelegate

extension TasksListInteractorImpl: TasksServiceDelegate,
								   ProjectsServiceDelegate {

	func onStorageChange() {
		fetchCachedTasks()
	}

}
