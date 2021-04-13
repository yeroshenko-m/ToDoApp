//
//  ProjectsServiceProtocol.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 24.02.2021.
//

import CoreData

protocol ProjectsServiceProtocol {

	func fetchAll(completion: @escaping VoidResultCompletion)

	func fetchProject(_ project: Project,
					  completion: @escaping VoidResultCompletion)

	func fetchCachedProjects(withPredicate filterPredicate: ProjectFilteringPredicates?,
							 sortedBy descriptors: [ProjectSortDescriptors]?,
							 completion: @escaping ResultCompletion<[Project]>)

	func makeNewProject(_ project: Project,
						completion: @escaping VoidResultCompletion)

	func updateProject(_ project: Project,
					   completion: @escaping VoidResultCompletion)

	func deleteProject(_ project: Project,
					   completion: @escaping VoidResultCompletion)

	func deleteAll(completion: @escaping VoidResultCompletion)

	// MARK: - Delegates

	func addDelegate(_ delegate: ProjectsServiceDelegate)

	func removeDelegate(_ delegate: ProjectsServiceDelegate)

}
