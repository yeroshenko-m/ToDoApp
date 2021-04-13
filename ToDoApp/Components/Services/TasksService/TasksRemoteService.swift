//
//  TasksRemoteService.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 02.03.2021.
//

import Foundation

final class TasksRemoteService {

	// MARK: - Properties

	private let networkManager: NetworkManager

	// MARK: - Init

	init(networkManager: NetworkManager) {
		self.networkManager = networkManager
	}

	// MARK: - API

	func fetchAllTasks(completion: @escaping ResultCompletion<[TaskDTO]>) {
		networkManager.call(type: EndPointType.getAllTasks) { (requestResult: Result<[TaskDTO], Error>) in
			switch requestResult {
			case .failure(let error):
				completion(.failure(error))
			case .success(let tasksDTO):
				completion(.success(tasksDTO))
			}
		}
	}

	func fetchSingleTask(byId id: Int,
						 completion: @escaping ResultCompletion<TaskDTO>) {
		networkManager.call(type: EndPointType.getTask(id: id)) { (requestResult: Result<TaskDTO, Error>) in
			switch requestResult {
			case .failure(let error):
				completion(.failure(error))
			case .success(let taskDTO):
				completion(.success(taskDTO))
			}
		}
	}

	func fetchTasksForProject(withId id: Int,
							  completion: @escaping ResultCompletion<[TaskDTO]>) {
		networkManager.call(type: EndPointType.getTasksForProject(id: id)) { (requestResult: Result<[TaskDTO], Error>) in
			switch requestResult {
			case .failure(let error):
				completion(.failure(error))
			case .success(let tasksDTO):
				completion(.success(tasksDTO))
			}
		}
	}

	func updateTask(byId id: Int,
					params: TaskRequestParams,
					completion: @escaping VoidResultCompletion) {
		networkManager.call(type: EndPointType.updateTask(id: id),
							params: params) { (result: Result<Void, Error>) in
			switch result {
			case .failure(let error):
				completion(.failure(error))
			case .success:
				completion(.success(()))
			}
		}
	}

	func makeTask(params: TaskRequestParams,
				  completion: @escaping ResultCompletion<TaskDTO>) {
		networkManager.call(type: EndPointType.makeTask,
							params: params) { (result: Result<TaskDTO, Error>) in
			switch result {
			case .failure(let error):
				completion(.failure(error))
			case .success(let taskDTO):
				completion(.success(taskDTO))
			}
		}
	}

	func deleteTask(byId id: Int,
					completion: @escaping VoidResultCompletion) {
		networkManager.call(type: EndPointType.deleteTask(id: id)) { (result: Result<Void, Error>) in
			switch result {
			case .failure(let error):
				completion(.failure(error))
			case .success:
				completion(.success(()))
			}
		}
	}

	func closeTask(byId id: Int,
				   completion: @escaping VoidResultCompletion) {
		networkManager.call(type: EndPointType.closeTask(id: id)) { (result: Result<Void, Error>) in
			switch result {
			case .failure(let error):
				completion(.failure(error))
			case .success:
				completion(.success(()))
			}
		}
	}

}
