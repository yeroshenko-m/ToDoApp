//
//  StorageManager.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 20.02.2021.
//

import CoreData

// TODO: Move CoreData operations to background queue.
final class StorageManager<Entity: DTOConfigurable, DTO: DataTransferObject>
	where Entity: NSManagedObject {

	// MARK: - Components

	private let coreDataStack: CoreDataStack
	var context: NSManagedObjectContext {
		coreDataStack.managedContext
	}

	// MARK: - Init

	init(stack: CoreDataStack) {
		self.coreDataStack = stack
	}

	// MARK: - Fetching

	func fetch(predicate: NSPredicate? = nil,
			   sortDescriptors: [NSSortDescriptor]? = nil,
			   completion: @escaping ResultCompletion<[Entity]>) {
		let fetchRequest = NSFetchRequest<Entity>(entityName: Entity.nameOfClass)
		fetchRequest.predicate = predicate
		fetchRequest.sortDescriptors = sortDescriptors
		do {
			let fetchResults = try coreDataStack.managedContext.fetch(fetchRequest)
			completion(.success(fetchResults))
		} catch let error as NSError {
			completion(.failure(error))
		}
	}

	// MARK: - Updating

	func update(_ storedObject: Entity,
				with object: ToDoObject,
				completion: @escaping VoidResultCompletion) {
		storedObject.update(withObject: object)
		coreDataStack.saveContext()
		completion(.success(()))
	}

	func update(_ storedObjects: [Entity],
				with dataTransferObjects: [DTO],
				completion: @escaping VoidResultCompletion) {
		for storedObject in storedObjects {
			for dataTransferObject in dataTransferObjects {
				if dataTransferObject.id == Int(storedObject.identifier) {
					do {
						if try storedObject.hasDifferences(from: dataTransferObject) {
							storedObject.configure(withObject: dataTransferObject)
						}
					} catch let error {
						completion(.failure(error))
					}
				}
			}
		}
		coreDataStack.saveContext()
		completion(.success(()))
	}

	// MARK: - Adding

	func add(object: DTO,
			 completion: @escaping VoidResultCompletion) {
		let objectModel = Entity(context: coreDataStack.managedContext)
		objectModel.configure(withObject: object)
		coreDataStack.saveContext()
		completion(.success(()))
	}

	func add(objects: [DTO],
			 completion: @escaping VoidResultCompletion) {
			objects.forEach { object in
				let managedObject = Entity(context: coreDataStack.managedContext)
				managedObject.configure(withObject: object)
			}
		coreDataStack.saveContext()
		completion(.success(()))
	}

	// MARK: - Deleting
	// Deleting implemented via context.delete(object) because of using relationships in CoreDataModel.
	// When use 'Batch delete request', it doesn't affect managedContext, and cascade deleting tasks with related project is impossible
	func delete(object: Entity,
				completion: @escaping VoidResultCompletion) {
		coreDataStack.managedContext.delete(object)
		completion(.success(()))
	}

	func deleteMultiple(with predicate: NSPredicate,
						completion: @escaping VoidResultCompletion) {
		let fetchRequest = NSFetchRequest<Entity>(entityName: Entity.entityName)
		fetchRequest.predicate = predicate
		let context = coreDataStack.managedContext
		do {
			let entities = try context.fetch(fetchRequest)
			for entity in entities {
				context.delete(entity)
			}
			coreDataStack.saveContext()
			completion(.success(()))
		} catch let error as NSError {
			completion(.failure(error))
		}
	}

	func deleteAll(completion: @escaping VoidResultCompletion) {
		let fetchRequest = NSFetchRequest<Entity>(entityName: Entity.entityName)
		let context = coreDataStack.managedContext
		do {
			let entities = try context.fetch(fetchRequest)
			for entity in entities {
				context.delete(entity)
			}
			coreDataStack.saveContext()
			completion(.success(()))
		} catch let error as NSError {
			completion(.failure(error))
		}
	}

}

extension StorageManager where Entity == TaskModel {

	func add(task: TaskDTO,
			 completion: @escaping VoidResultCompletion) {
		fetchRelatedProject(id: task.projectId) { [weak self] projectResult in
			guard let self = self else { return }
			switch projectResult {
			case .failure(let error):
				completion(.failure(error))
				return
			case .success(let projectModel):
				let taskModel = Entity(context: self.coreDataStack.managedContext)
				taskModel.configure(withObject: task)
				taskModel.project = projectModel
				projectModel.addToTasks(taskModel)
				self.coreDataStack.saveContext()
				completion(.success(()))
			}
		}
	}

	func add(tasks: [TaskDTO],
			 completion: @escaping VoidResultCompletion) {

		let projectsIds = tasks.map { $0.projectId }
		var projects = [ProjectModel]()

		projectsIds.forEach { id in
			fetchRelatedProject(id: id) { projectResult in
				switch projectResult {
				case .failure(let error):
					completion(.failure(error))
					return
				case .success(let projectModel):
					projects.append(projectModel)
				}
			}
		}

		for (index, task) in tasks.enumerated() {
			let taskModel = Entity(context: coreDataStack.managedContext)
			taskModel.configure(withObject: task)
			taskModel.project = projects[index]
			projects[index].addToTasks(taskModel)
		}

		coreDataStack.saveContext()
		completion(.success(()))

	}

	func deleteAll(completion: @escaping VoidResultCompletion) {
		let fetchRequest = NSFetchRequest<Entity>(entityName: Entity.entityName)
		let context = coreDataStack.managedContext
		do {
			let entities = try context.fetch(fetchRequest)
			for entity in entities {
				entity.project?.removeFromTasks(entity)
				context.delete(entity)
			}
			coreDataStack.saveContext()
			completion(.success(()))
		} catch let error as NSError {
			completion(.failure(error))
		}
	}

	func delete(object: Entity,
				completion: @escaping VoidResultCompletion) {
		object.project?.removeFromTasks(object)
		coreDataStack.managedContext.delete(object)
		completion(.success(()))
	}

	func deleteMultiple(with predicate: NSPredicate,
						completion: @escaping VoidResultCompletion) {
		let fetchRequest = NSFetchRequest<Entity>(entityName: Entity.entityName)
		fetchRequest.predicate = predicate
		let context = coreDataStack.managedContext
		do {
			let entities = try context.fetch(fetchRequest)
			for entity in entities {
				entity.project?.removeFromTasks(entity)
				context.delete(entity)
			}
			coreDataStack.saveContext()
			completion(.success(()))
		} catch let error as NSError {
			completion(.failure(error))
		}
	}

	private func fetchRelatedProject(id: Int,
									 completion: @escaping ResultCompletion<ProjectModel>) {
		let fetchRequest = NSFetchRequest<ProjectModel>(entityName: ProjectModel.nameOfClass)
		fetchRequest.predicate = ProjectFilteringPredicates.hasId(id).predicate
		do {
			let fetchResults = try coreDataStack.managedContext.fetch(fetchRequest)
			guard let projectModel = fetchResults.first
			else {
				return completion(.failure(StorageManagerError.cantFetchStoredRecord))
			}
			return completion(.success(projectModel))
		} catch let error as NSError {
			return completion(.failure(error))
		}
	}

}
