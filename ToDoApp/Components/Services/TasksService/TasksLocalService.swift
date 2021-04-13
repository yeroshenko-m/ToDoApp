//
//  TasksLocalService.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 02.03.2021.
//

import Foundation

struct SortedObjects<DTO: DataTransferObject, Model: DTOConfigurable> {
	let newDTO: [DTO]
	let updatedDTO: [DTO]
	let modelsToUpdate: [Model]
	let existingNotUpdatedDTO: [DTO]
}

final class TasksLocalService {

	// MARK: - Properties

	private let storageManager: StorageManager<TaskModel, TaskDTO>

	// MARK: - Init

	init(storageManager: StorageManager<TaskModel, TaskDTO>) {
		self.storageManager = storageManager
	}

	// MARK: - API

	func fetchFromStorage(withPredicate filterPredicate: TaskFilteringPredicates? = nil,
						  sortedBy descriptors: [TaskSortDescriptors]? = nil,
						  completion: @escaping ResultCompletion<[Task]>) {
		self.storageManager.fetch(predicate: filterPredicate?.predicate,
								  sortDescriptors: descriptors?.map(\.sortDescriptor)) { fetchingResult in
			switch fetchingResult {
			case .failure(let error):
				completion(.failure(error))
			case .success(let taskModels):
				completion(.success(taskModels.map(\.asTask)))
			}
		}
	}

	func storeTask(_ taskDTO: TaskDTO,
				   completion: @escaping VoidResultCompletion) {
		storageManager.add(task: taskDTO) { storingResult in
			switch storingResult {
			case .failure(let error):
				completion(.failure(error))
			case .success:
				completion(.success(()))
			}
		}
	}

	func storeTasks(_ tasksDTO: [TaskDTO],
					completion: @escaping VoidResultCompletion) {
		storageManager.deleteAll { [weak self] deletionResult in
			switch deletionResult {
			case .failure(let error):
				completion(.failure(error))
			case .success:
				self?.storageManager.add(tasks: tasksDTO) { storingResult in
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

	func storeNew(tasksDTO: [TaskDTO],
				  completion: @escaping VoidResultCompletion) {
		storageManager.fetch { [weak self] fetchResult in
			guard let self = self else { return }
			switch fetchResult {
			case .failure(let error):
				completion(.failure(error))
			case .success(let taskModels):
				do {
					let sortedTaskData = try sort(dataTransferObjects: tasksDTO, cachedModels: taskModels)

					var isAddingSuccessful = false
					var isUpdatingSuccessful = false

					let group = DispatchGroup()

					group.enter()
					self.storageManager.add(tasks: sortedTaskData.newDTO) { result in
						switch result {
						case .failure(let error):
							completion(.failure(error))
							return
						case .success:
							isAddingSuccessful = true
						}
						group.leave()
					}

					group.enter()
					self.update(taskModels: sortedTaskData.modelsToUpdate,
								with: sortedTaskData.updatedDTO) { result in
						switch result {
						case .failure(let error):
							completion(.failure(error))
							return
						case .success:
							isUpdatingSuccessful = true
						}
						group.leave()
					}

					group.notify(queue: .main) {
						if isAddingSuccessful && isUpdatingSuccessful {
							completion(.success(()))
						}
					}

				} catch let error {
					completion(.failure(error))
					return
				}
			}
		}
	}

	func updateStoredTask(task: Task,
						  completion: @escaping VoidResultCompletion) {
		let predicate = TaskFilteringPredicates.hasId(task.id).predicate
		storageManager.fetch(predicate: predicate) { [weak self] fetchingResult in
			guard let self = self else { return }
			switch fetchingResult {
			case .failure(let error):
				completion(.failure(error))
			case .success(let taskModels):
				guard let taskModelToUpdate = taskModels.first
				else {
					completion(.failure(StorageManagerError.cantFetchStoredRecord))
					return
				}
				self.update(taskModel: taskModelToUpdate, with: task, completion: completion)
			}
		}

	}

	func deleteStoredTask(task: Task,
						  completion: @escaping VoidResultCompletion) {
		let predicate = TaskFilteringPredicates.hasId(task.id).predicate
		storageManager.fetch(predicate: predicate) { [weak self] fetchingResult in
			guard let self = self else { return }
			switch fetchingResult {
			case .failure(let error):
				completion(.failure(error))
			case .success(let taskModels):
				guard let taskModelToDelete = taskModels.first
				else {
					completion(.failure(StorageManagerError.cantFetchStoredRecord))
					return
				}
				self.delete(task: taskModelToDelete, completion: completion)
			}
		}
	}

	func deleteAllStoredTasks(completion: @escaping VoidResultCompletion) {
		storageManager.deleteAll { deletionResult in
			switch deletionResult {
			case .failure(let error):
				completion(.failure(error))
			case .success:
				completion(.success(()))
			}
		}
	}

	// MARK: - Private implementation

	private func update(taskModels: [TaskModel],
						with tasksDTO: [TaskDTO],
						completion: @escaping VoidResultCompletion) {
		storageManager.update(taskModels, with: tasksDTO, completion: completion)
	}

	private func update(taskModel: TaskModel,
						with task: Task,
						completion: @escaping VoidResultCompletion) {
		storageManager.update(taskModel, with: task, completion: completion)
	}

	func delete(task: TaskModel,
				completion: @escaping VoidResultCompletion) {
		storageManager.delete(object: task) { deletionResult in
			switch deletionResult {
			case .failure(let error):
				completion(.failure(error))
			case .success:
				completion(.success(()))
			}
		}
	}

}
