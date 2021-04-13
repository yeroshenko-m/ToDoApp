//
//  ProjectsService.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 26.01.2021.
//

import CoreData
import WatchConnectivity

final class ProjectsService: ProjectsServiceProtocol {

	// MARK: - Shared instance

	static let shared = ProjectsService()

	// MARK: - Components

	private let localService: ProjectsLocalService
	private let remoteService: ProjectsRemoteService
	private let notificationCenter: NotificationCenter
	private let watchConnectivitySession: WCSession

	private var multicastDelegates = MulticastDelegate<ProjectsServiceDelegate>()

	// MARK: - Init

	init() {
		let container = StoreContainer.container
		let networkManager = NetworkManager.shared
		localService = ProjectsLocalService(storageManager: StorageManager<ProjectModel,
																		   ProjectDTO>(stack: .init(storeContainer: container)))
		remoteService = ProjectsRemoteService(networkManager: networkManager)
		notificationCenter = .default
		watchConnectivitySession = .default
		subscribeForNotifications(storageContext: container.viewContext)
	}

	// MARK: - Delegate

	func addDelegate(_ delegate: ProjectsServiceDelegate) {
		multicastDelegates.add(delegate)
	}

	func removeDelegate(_ delegate: ProjectsServiceDelegate) {
		multicastDelegates.remove(delegate)
	}

	// MARK: - Public API

	func fetchAll(completion: @escaping VoidResultCompletion) {
		remoteService.fetchAllProjects { apiFetchingResult in
			switch apiFetchingResult {
			case .failure(let error):
				completion(.failure(error))
			case .success(let projectsDTO):
				self.localService.storeNew(projectsDTO: projectsDTO, completion: completion)
			}
		}
	}

	func fetchProject(_ project: Project,
					  completion: @escaping VoidResultCompletion) {
		remoteService.fetchSingleProject(byId: project.id) { apiFetchingResult in
			switch apiFetchingResult {
			case .failure(let error):
				completion(.failure(error))
			case .success(let projectDTO):
				self.localService.storeProject(projectDTO,
											   completion: completion)
			}
		}
	}

	func fetchCachedProjects(withPredicate filterPredicate: ProjectFilteringPredicates? = nil,
							 sortedBy descriptors: [ProjectSortDescriptors]? = nil,
							 completion: @escaping ResultCompletion<[Project]>) {
		localService.fetchFromStorage(withPredicate: filterPredicate,
									  sortedBy: descriptors,
									  completion: completion)
	}

	func makeNewProject(_ project: Project,
						completion: @escaping VoidResultCompletion) {
		let params = ProjectRequestParams(project: project)
		remoteService.makeProject(params: params) { apiMakingResult in
			switch apiMakingResult {
			case .failure(let error):
				completion(.failure(error))
			case .success(let projectDTO):
				self.localService.storeProject(projectDTO, completion: completion)
			}
		}
	}

	func updateProject(_ project: Project,
					   completion: @escaping VoidResultCompletion) {
		let params = ProjectRequestParams(project: project)
		remoteService.updateProject(byId: project.id,
									params: params) { apiUpdatingResult in
			switch apiUpdatingResult {
			case .failure(let error):
				completion(.failure(error))
			case .success:
				self.localService.updateStored(project: project, completion: completion)
			}
		}
	}

	func deleteProject(_ project: Project,
					   completion: @escaping VoidResultCompletion) {
		remoteService.deleteProject(byId: project.id) { apiDeletingResult in
			switch apiDeletingResult {
			case .failure(let error):
				completion(.failure(error))
			case .success:
				self.localService.deleteStored(project: project, completion: completion)
			}
		}
	}

	func deleteAll(completion: @escaping VoidResultCompletion) {
		localService.deleteAllStoredProjects(completion: completion)
	}

	// MARK: - Private implementation

	// TODO: Handle errors
	private func updateDataOnWatchApp() {
		guard WCSession.isSupported() else { return }
		fetchCachedProjects(sortedBy: [.favoriteFirst, .nameAZ]) { fetchingResult in
			switch fetchingResult {
			case .failure(let error):
				print(error.localizedDescription)
			case .success(let projects):
				self.sendToWatchApp(projects: projects)
			}
		}
	}

	// TODO: Handle errors
	private func sendToWatchApp(projects: [Project]) {
		guard WCSession.isSupported() else { return }
		guard let projectsData = try? JSONEncoder().encode(projects) else {
			return
		}
		let updatedContext = [WatchDataTypeSyncKey.projects: projectsData]

		do {
			try watchConnectivitySession.updateApplicationContext(updatedContext)
		} catch let error {
			print(error.localizedDescription)
		}

	}

	private func subscribeForNotifications(storageContext: NSManagedObjectContext) {
		notificationCenter.addObserver(self, selector: #selector(managedObjectContextDidChange(_:)),
									   name: .NSManagedObjectContextObjectsDidChange,
									   object: storageContext)
		notificationCenter.addObserver(self, selector: #selector(clearUserData),
									   name: AuthService.logoutNotificationName,
									   object: nil)
	}

	// MARK: - Selector

	@objc
	private func managedObjectContextDidChange(_ notification: NSNotification) {
		guard let userInfo = notification.userInfo else { return }
		for key in [NSInsertedObjectsKey, NSUpdatedObjectsKey, NSDeletedObjectsKey] {
			if let changes = userInfo[key] as? Set<ProjectModel>,
			   !changes.isEmpty {
				self.multicastDelegates.invoke({ $0.onStorageChange() })
				updateDataOnWatchApp()
			}
		}
	}

	@objc
	private func clearUserData() {
		localService.deleteAllStoredProjects { _ in }
		sendToWatchApp(projects: [])
	}

}
