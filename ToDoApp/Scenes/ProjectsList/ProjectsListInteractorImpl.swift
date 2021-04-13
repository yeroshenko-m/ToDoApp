//
//  ProjectsListInteractor.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 05.03.2021.
//

import Foundation

// MARK: - Protocol

protocol ProjectsListInteractor {
	func delete(project: Project)
	func update(project: Project)
	func fetchProjects()
	func searchProject(by phrase: String)
	
	var projectsOrderStorage: ProjectsOrderStorage { get set }
}

// MARK: - Interactor

final class ProjectsListInteractorImpl {
	
	// MARK: - Properties

	private let notificationCenter: NotificationCenter
	private let presenter: ProjectsListPresenter
	private let projectsService: ProjectsService
	private let reachabilityManager: ReachabilityManager
	private var debounceSearchProjectWorkItem: DispatchWorkItem?
	
	var projectsOrderStorage = ProjectsOrderStorage()
	
	// MARK: - Init
	
	init(projectsService: ProjectsService,
		 presenter: ProjectsListPresenter) {
		self.projectsService = projectsService
		self.presenter = presenter
		notificationCenter = NotificationCenter.default
		reachabilityManager = ReachabilityManager.shared
		self.projectsService.addDelegate(self)
		configReachability()
	}

	// MARK: - Deinit

	deinit {
		notificationCenter.removeObserver(self,
										  name: .reachabilityChanged,
										  object: nil)
		projectsService.removeDelegate(self)
	}
	
}

// MARK: - Business logic

extension ProjectsListInteractorImpl: ProjectsListInteractor {

	// TODO: - Fix double network call
	func fetchProjects() {
		guard reachabilityManager.isReachable else {
			fetchCachedProjects()
			return
		}
		fetchCachedProjects {
			self.projectsService.fetchAll { [weak self] result in
				guard let self = self else { return }
				self.handle(result)
			}
		}
	}
	
	func delete(project: Project) {
		guard reachabilityManager.isReachable else {
			presenter.presentOfflineError(.deviceOffline,
										  message: R.string.localizable.reachability_deleteProject())
			return
		}
		
		projectsService.deleteProject(project) { [weak self] projectsResult in
			guard let self = self else { return }
			self.handle(projectsResult)
		}
	}
	
	func update(project: Project) {
		projectsService.updateProject(project) { [weak self] result in
			guard let self = self else { return }
			self.handle(result)
		}
	}
	
	func searchProject(by phrase: String) {
		debounceSearchProjectWorkItem?.cancel()
		let newSearchItem = DispatchWorkItem { [weak self] in
			self?.projectsService.fetchCachedProjects(withPredicate: ProjectFilteringPredicates.nameContains(phrase),
													  sortedBy: [.favoriteFirst, .nameAZ]) { fetchingResult in
				self?.presenter.presentSearch(result: fetchingResult)
			}
		}
		
		Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
			DispatchQueue.main.async(execute: newSearchItem)
		}
		
		debounceSearchProjectWorkItem = newSearchItem
	}
	
	// MARK: - Private implementation
	
	private func handle(_ result: Result<Void, Error>) {
		switch result {
		case .failure(let error):
			self.presenter.present(result: .failure(error))
		case .success:
			presenter.presentFetchingSuccess()
		}
	}

	private func fetchCachedProjects(completion: (() -> Void)? = nil) {
		var sortDescriptors = projectsOrderStorage.allSortDescriptors()
		sortDescriptors.append(.nameAZ)
		projectsService.fetchCachedProjects(sortedBy: sortDescriptors) { [weak self] fetchingResult in
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
		case .unavailable: return
		default: fetchProjects()
		}
	}
	
}

// MARK: - ProjectsServiceDelegate

extension ProjectsListInteractorImpl: ProjectsServiceDelegate {

	func onStorageChange() {
		fetchCachedProjects()
	}
	
}
