//
//  ProjectsLocalService.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 01.03.2021.
//

import Foundation

final class ProjectsLocalService {

	// MARK: - Properties

	private let storageManager: StorageManager<ProjectModel, ProjectDTO>

	// MARK: - Init

	init(storageManager: StorageManager<ProjectModel, ProjectDTO>) {
		self.storageManager = storageManager
	}

	// MARK: - API

	func fetchFromStorage(withPredicate filterPredicate: ProjectFilteringPredicates? = nil,
						  sortedBy descriptors: [ProjectSortDescriptors]? = nil,
						  completion: @escaping ResultCompletion<[Project]>) {
		self.storageManager.fetch(predicate: filterPredicate?.predicate,
								  sortDescriptors: descriptors?.map(\.sortDescriptor)) { fetchingResult in
			switch fetchingResult {
			case .failure(let error):
				completion(.failure(error))
			case .success(let projectModels):
				var projects: [Project] = projectModels.map(\.asProject)
				projects.sort(by: { $0.name == "Inbox" && $1.name != "Inbox" })
				completion(.success(projects))
			}
		}
	}

	func storeProject(_ projectDTO: ProjectDTO,
					  completion: @escaping VoidResultCompletion) {
		storageManager.add(object: projectDTO) { storingResult in
			switch storingResult {
			case .failure(let error):
				completion(.failure(error))
			case .success:
				completion(.success(()))
			}
		}
	}

	func storeNew(projectsDTO: [ProjectDTO],
				  completion: @escaping VoidResultCompletion) {
		storageManager.fetch { [weak self] fetchResult in
			guard let self = self else { return }
			switch fetchResult {
			case .failure(let error):
				completion(.failure(error))
			case .success(let projectModels):
				do {
					let sortedProjectsData = try sort(dataTransferObjects: projectsDTO,
													  cachedModels: projectModels)
					var isAddingSuccessful = false
					var isUpdatingSuccessful = false

					let group = DispatchGroup()

					// TODO: REMOVE DOUBLE ERROR COMPLETION
					group.enter()
					self.storageManager.add(objects: sortedProjectsData.newDTO) { result in
						switch result {
						case .failure(let error):
							completion(.failure(error))
							isAddingSuccessful = false

						case .success:
							isAddingSuccessful = true
						}
						group.leave()
					}

					group.enter()
					self.update(projectModels: sortedProjectsData.modelsToUpdate,
								with: sortedProjectsData.updatedDTO) { result in
						switch result {
						case .failure(let error):
							completion(.failure(error))
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

	func updateStored(project: Project, completion: @escaping VoidResultCompletion) {
		let predicate = ProjectFilteringPredicates.hasId(project.id).predicate
		storageManager.fetch(predicate: predicate) { [weak self] fetchingResult in
			guard let self = self else { return }
			switch fetchingResult {
			case .failure(let error):
				completion(.failure(error))
			case .success(let projectModels):
				guard let projectModelToUpdate = projectModels.first
				else {
					completion(.failure(StorageManagerError.cantFetchStoredRecord))
					return
				}
				self.update(projectModel: projectModelToUpdate, with: project, completion: completion)
			}
		}

	}

	func deleteStored(project: Project, completion: @escaping VoidResultCompletion) {
		let predicate = ProjectFilteringPredicates.hasId(project.id).predicate
		storageManager.fetch(predicate: predicate) { [weak self] fetchingResult in
			guard let self = self else { return }
			switch fetchingResult {
			case .failure(let error):
				completion(.failure(error))
			case .success(let projectModels):
				guard let projectModelToDelete = projectModels.first
				else {
					completion(.failure(StorageManagerError.cantFetchStoredRecord))
					return
				}
				self.delete(project: projectModelToDelete, completion: completion)
			}
		}
	}

	func deleteAllStoredProjects(completion: @escaping VoidResultCompletion) {
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

	private func update(projectModels: [ProjectModel],
						with projectsDTO: [ProjectDTO],
						completion: @escaping VoidResultCompletion) {
		storageManager.update(projectModels, with: projectsDTO, completion: completion)
	}

	private func update(projectModel: ProjectModel,
						with project: Project,
						completion: @escaping VoidResultCompletion) {
		storageManager.update(projectModel, with: project, completion: completion)
	}

	func delete(project: ProjectModel,
				completion: @escaping VoidResultCompletion) {
		storageManager.delete(object: project) { deletionResult in
			switch deletionResult {
			case .failure(let error):
				completion(.failure(error))
			case .success:
				completion(.success(()))
			}
		}
	}

}
