//
//  RequestItems.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 26.02.2021.
//

import Alamofire

enum EndPointType {
	
	case auth
	case token(clientId: String,
			   secret: String,
			   code: String,
			   redirectURL: String)
	
	case getAllTasks
	case getTask(id: Int)
	case getTasksForProject(id: Int)
	case makeTask
	case updateTask(id: Int)
	case deleteTask(id: Int)
	case closeTask(id: Int)
	
	case getAllProjects
	case getProject(id: Int)
	case makeProject
	case updateProject(id: Int)
	case deleteProject(id: Int)
	
}

extension EndPointType: EndPointTypeProtocol {
	
	// MARK: - Properties
	
	var baseURL: String {
		"https://api.todoist.com/"
	}
	
	var path: String {
		switch self {
		case .auth:
			return "oauth/authorize"
			
		case .token(let clientId,
					let secret,
					let code,
					let redirectURL):
			return "oauth/access_token?client_id=\(clientId)&client_secret=\(secret)&code=\(code)&redirect_url=\(redirectURL)"
			
		case .getAllTasks,
			 .makeTask:
			return "rest/v1/tasks"

		case .getTasksForProject(let id):
			return "rest/v1/tasks?project_id=\(id)"

		case .closeTask(let id):
			return "rest/v1/tasks/\(id)/close"
			
		case .getTask(let id),
			 .updateTask(let id),
			 .deleteTask(let id):
			return "rest/v1/tasks/\(id)"
			
		case .getAllProjects,
			 .makeProject:
			return "rest/v1/projects"
			
		case .getProject(let id),
			 .updateProject(let id),
			 .deleteProject(let id):
			return "rest/v1/projects/\(id)"
		}
	}
	
	var httpMethod: HTTPMethod {
		switch self {
		case .auth,
			 .getTask,
			 .getAllTasks,
			 .getProject,
			 .getAllProjects,
			 .getTasksForProject:
			 return .get
			
		case .token,
			 .makeTask,
			 .makeProject,
			 .updateTask,
			 .updateProject,
			 .closeTask:
			return .post
			
		case .deleteTask,
			 .deleteProject:
			return .delete
		}
	}
	
	var headers: HTTPHeaders? {
		switch self {
		case .getTask,
			 .getAllTasks,
			 .getProject,
			 .getAllProjects,
			 .deleteTask,
			 .deleteProject,
			 .closeTask,
			 .getTasksForProject:
			return [HTTPHeader(name: "Authorization",
							   value: AuthService().authTokenString ?? String())]
			
		case .makeTask,
			 .makeProject,
			 .updateTask,
			 .updateProject:
			return [HTTPHeader(name: "Authorization",
							   value: AuthService().authTokenString ?? String()),
					HTTPHeader(name: "Content-Type",
							   value: "application/json")]
			
		case .auth,
			 .token:
			return nil
		}
	}
	
	var url: URL {
		switch self {
		default:
			return URL(string: self.baseURL + self.path)!
		}
	}
	
	var encoding: ParameterEncoding {
		switch self {
		default:
			return JSONEncoding.default
		}
	}
	
}
