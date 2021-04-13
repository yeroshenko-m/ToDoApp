//
//  StorageManager.swift
//  ToDoWatchApp Extension
//
//  Created by Mykhailo Yeroshenko on 10.04.2021.
//

import Foundation

final class WatchStorageManager {

	// MARK: - SHared instance

	static var shared = WatchStorageManager()

	// MARK: - External Properties

	// MARK: - Internal properties

	private let storage: UserDefaults

	// MARK: - Private init

	private init() {
		storage = .standard
	}

	// MARK: - Fetch auth data

	func fetchAuthData() -> Bool {
		let string = storage.string(forKey: WatchDataTypeSyncKey.isAuthorized)
		return string == "LoggedIn"
	}

	// MARK: - FetchProjects

	func fetchCachedProjects() -> [Project]? {
		guard
			let projectsData = storage.data(forKey: WatchDataTypeSyncKey.projects),
			let projects = try? JSONDecoder().decode([Project].self, from: projectsData)
		else { return nil }
		return projects
	}

	// MARK: - FetchTasks

	func fetchCachedTasks() -> [Task]? {
		guard
			let tasksData = storage.data(forKey: WatchDataTypeSyncKey.tasks),
			let tasks = try? JSONDecoder().decode([Task].self, from: tasksData)
		else { return nil }
		return tasks
	}

	func fetchCachedTasksDateSections() -> [TasksListSection]? {
		guard let tasks = fetchCachedTasks() else { return nil }
		return TasksSectionsMapper.mapToSectionsByDate(tasks: tasks)
	}

	func fetchCachedTasksProjectSections() -> [TasksListSection]? {
		guard let tasks = fetchCachedTasks() else { return nil }
		return TasksSectionsMapper.mapToSectionsByProject(tasks: tasks)
	}

	func fetchCachedTasksForProject(named projectName: String) -> [Task]? {
		guard let tasks = fetchCachedTasks() else { return nil }
		return tasks.filter({ $0.projectName == projectName })
	}

	func fetchCachedTask(witIdentifier id: Int) -> Task? {
		guard let tasks = fetchCachedTasks() else { return nil }
		return tasks.filter { $0.id == id } .first
	}

	// MARK: - Store API

	func store(projectsData: Data) {
		storage.setValue(projectsData,
						 forKey: WatchDataTypeSyncKey.projects)
	}

	func store(tasksData: Data) {
		storage.setValue(tasksData,
						 forKey: WatchDataTypeSyncKey.tasks)
	}

	func store(authState state: String) {
		storage.set(state, forKey: WatchDataTypeSyncKey.isAuthorized)
	}

}
