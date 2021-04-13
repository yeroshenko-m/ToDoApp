//
//  TasksServiceProtocol.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 26.02.2021.
//

import Foundation

protocol TasksServiceProtocol {

	func fetchAll(completion: @escaping VoidResultCompletion)
	
	func fetchTask(_ task: Task,
				   completion: @escaping VoidResultCompletion)
	
	func fetchTasksForProject(_ project: Project,
							  completion: @escaping VoidResultCompletion)
	
	func fetchCachedTasks(withPredicate filterPredicate: TaskFilteringPredicates?,
						  sortedBy descriptors: [TaskSortDescriptors]?,
						  completion: @escaping ResultCompletion<[Task]>)
	
	func makeNewTask(_ task: Task,
					 completion: @escaping VoidResultCompletion)
	
	func updateTask(_ task: Task,
					completion: @escaping VoidResultCompletion)
	
	func deleteTask(_ task: Task,
					completion: @escaping VoidResultCompletion)
	
	func deleteAll(completion: @escaping VoidResultCompletion)
	
	func closeTask(_ task: Task,
				   completion: @escaping VoidResultCompletion)

	// MARK: - Delegates

	func addDelegate(_ delegate: TasksServiceDelegate)

	func removeDelegate(_ delegate: TasksServiceDelegate)

}
