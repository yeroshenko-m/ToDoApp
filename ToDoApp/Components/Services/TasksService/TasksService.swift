//
//  TasksService.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 02.02.2021.
//

import CoreData
import WatchConnectivity

final class TasksService: TasksServiceProtocol {

	// MARK: - Shared instance

	static let shared = TasksService()

	// MARK: - Components

	private let localService: TasksLocalService
	private let remoteService: TasksRemoteService
	private let notificationCenter: NotificationCenter
	private let watchConnectivitySession: WCSession

	private var multicastDelegates = MulticastDelegate<TasksServiceDelegate>()

	// MARK: - Init

	private init() {
		let container = StoreContainer.container
		let networkManager = NetworkManager.shared
		localService = TasksLocalService(storageManager: StorageManager<TaskModel,
																		TaskDTO>(stack: .init(storeContainer: container)))
		remoteService = TasksRemoteService(networkManager: networkManager)
		notificationCenter = .default
		watchConnectivitySession = .default
		subscribeForNotifications(storageContext: container.viewContext)
	}

	// MARK: - Delegate

	func addDelegate(_ delegate: TasksServiceDelegate) {
		multicastDelegates.add(delegate)
	}

	func removeDelegate(_ delegate: TasksServiceDelegate) {
		multicastDelegates.remove(delegate)
	}

	// MARK: - Public API

	func fetchAll(completion: @escaping VoidResultCompletion) {
		remoteService.fetchAllTasks { [weak self] apiFetchingResult in
			guard let self = self else { return }
			switch apiFetchingResult {
			case .failure(let error):
				completion(.failure(error))
			case .success(let tasksDTO):
				self.localService.storeNew(tasksDTO: tasksDTO, completion: completion)
			}
		}
	}

	func fetchTask(_ task: Task,
				   completion: @escaping VoidResultCompletion) {
		remoteService.fetchSingleTask(byId: task.id) { [weak self] apiFetchingResult in
			guard let self = self else { return }
			switch apiFetchingResult {
			case .failure(let error):
				completion(.failure(error))
			case .success(let taskDTO):
				self.localService.storeTask(taskDTO, completion: completion)
			}
		}
	}

	func fetchTasksForProject(_ project: Project,
							  completion: @escaping VoidResultCompletion) {
		remoteService.fetchTasksForProject(withId: project.id) { [weak self] apiFetchingResult in
			guard let self = self else { return }
			switch apiFetchingResult {
			case .failure(let error):
				completion(.failure(error))
			case .success(let tasksDTO):
				self.localService.storeNew(tasksDTO: tasksDTO) { storingResult in
					switch storingResult {
					case .failure(let error):
						completion(.failure(error))
					case .success:
						completion(.success(()))
					}
				}
			}
		}
	}

	func fetchCachedTasks(withPredicate filterPredicate: TaskFilteringPredicates? = nil,
						  sortedBy descriptors: [TaskSortDescriptors]? = nil,
						  completion: @escaping ResultCompletion<[Task]>) {
		localService.fetchFromStorage(withPredicate: filterPredicate,
									  sortedBy: descriptors,
									  completion: completion)
	}

	func makeNewTask(_ task: Task,
					 completion: @escaping VoidResultCompletion) {
		let params = TaskRequestParams(task: task)
		remoteService.makeTask(params: params) { [weak self] apiMakingResult in
			guard let self = self else { return }
			switch apiMakingResult {
			case .failure(let error):
				completion(.failure(error))
			case .success(let taskDTO):
				self.localService.storeTask(taskDTO, completion: completion)
			}
		}
	}

	func updateTask(_ task: Task,
					completion: @escaping VoidResultCompletion) {
		let params = TaskRequestParams(task: task)
		remoteService.updateTask(byId: task.id,
								 params: params) { [weak self] apiUpdatingResult in
			guard let self = self else { return }
			switch apiUpdatingResult {
			case .failure(let error):
				completion(.failure(error))
			case .success:
				self.localService.updateStoredTask(task: task, completion: completion)
			}
		}
	}

	func deleteTask(_ task: Task,
					completion: @escaping VoidResultCompletion) {
		remoteService.deleteTask(byId: task.id) { [weak self] apiDeletingResult in
			guard let self = self else { return }
			switch apiDeletingResult {
			case .failure(let error):
				completion(.failure(error))
			case .success:
				self.localService.deleteStoredTask(task: task, completion: completion)
			}
		}
	}

	func deleteAll(completion: @escaping VoidResultCompletion) {
		localService.deleteAllStoredTasks(completion: completion)
	}

	func closeTask(_ task: Task,
				   completion: @escaping VoidResultCompletion) {
		remoteService.closeTask(byId: task.id) { [weak self] apiClosingResult in
			guard let self = self else { return }
			switch apiClosingResult {
			case .failure(let error):
				completion(.failure(error))
			case .success:
				self.localService.deleteStoredTask(task: task) { deletionResult in
					switch deletionResult {
					case .failure(let error):
						completion(.failure(error))
					case .success:
						completion(.success(()))
					}
				}
			}
		}
	}

	// MARK: - Private implementation

	// TODO: Handle errors
	private func updateDataOnWatchApp() {
		guard WCSession.isSupported() else { return }
		fetchCachedTasks(sortedBy: [.createdAscending, .nameAZ]) { fetchingResult in
			switch fetchingResult {
			case .failure(let error):
				print(error.localizedDescription)
			case .success(let tasks):
				self.sendToWatchApp(tasks: tasks)
			}
		}
	}

	// TODO: Handle errors
	private func sendToWatchApp(tasks: [Task]) {
		guard let tasksData = try? JSONEncoder().encode(tasks) else {
			return
		}
		let updatedContext = [WatchDataTypeSyncKey.tasks: tasksData]

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
			if let changes = userInfo[key] as? Set<TaskModel>,
			   !changes.isEmpty {
				multicastDelegates.invoke({ $0.onStorageChange() })
				updateDataOnWatchApp()
			}
		}
	}

	@objc
	private func clearUserData() {
		localService.deleteAllStoredTasks { _ in }
		sendToWatchApp(tasks: [])
	}

}
