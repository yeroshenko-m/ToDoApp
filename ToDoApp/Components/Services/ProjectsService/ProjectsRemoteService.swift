//
//  ProjectsRemoteService.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 01.03.2021.
//

import Foundation

final class ProjectsRemoteService {

	// MARK: - Properties

	private let networkManager: NetworkManager

	// MARK: - Init

	init(networkManager: NetworkManager) {
		self.networkManager = networkManager
	}

	// MARK: - API

	func fetchAllProjects(completion: @escaping ResultCompletion<[ProjectDTO]>) {
		networkManager.call(type: EndPointType.getAllProjects) { (result: Result<[ProjectDTO], Error>) in
			switch result {
			case .failure(let error):
				completion(.failure(error))
			case .success(let projectsDTO):
				completion(.success(projectsDTO))
			}
		}
	}

	func fetchSingleProject(byId id: Int,
							completion: @escaping (Result<ProjectDTO, Error>) -> Void) {
		networkManager.call(type: EndPointType.getProject(id: id)) { (result: Result<ProjectDTO, Error>) in
			switch result {
			case .failure(let error):
				completion(.failure(error))
			case .success(let projectDTO):
				completion(.success(projectDTO))
			}
		}
	}

	func updateProject(byId id: Int,
					   params: ProjectRequestParams,
					   completion: @escaping VoidResultCompletion) {
		networkManager.call(type: EndPointType.updateProject(id: id), params: params) { (result: Result<Void, Error>) in
			switch result {
			case .failure(let error):
				completion(.failure(error))
			case .success:
				completion(.success(()))
			}
		}
	}

	func makeProject(params: ProjectRequestParams,
					 completion: @escaping ResultCompletion<ProjectDTO>) {
		networkManager.call(type: EndPointType.makeProject,
							params: params) { (result: Result<ProjectDTO, Error>) in
			switch result {
			case .failure(let error):
				completion(.failure(error))
			case .success(let projectDTO):
				completion(.success(projectDTO))
			}
		}
	}

	func deleteProject(byId id: Int,
					   completion: @escaping VoidResultCompletion) {
		let requestType = EndPointType.deleteProject(id: id)
		networkManager.call(type: requestType) { (result: Result<Void, Error>) in
			switch result {
			case .failure(let error):
				completion(.failure(error))
			case .success:
				completion(.success(()))
			}
		}
	}

}
