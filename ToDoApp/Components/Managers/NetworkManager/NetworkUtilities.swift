//
//  NetworkManager.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 26.01.2021.
//

import Foundation

enum APIEndpoints: String {
    case projects = "/projects"
    case tasks = "/tasks"
    case labels = "/labels"
    case comments = "/comments"
    
    private static let base = "https://api.todoist.com/rest/v1"
    
    func make(_ type: Self) -> String { return APIEndpoints.base + type.rawValue }
}

enum AuthRequestConsts {
    static let redirectURL = "https://myapp.gov"
    static let clientId = "b411e53b25e84051abdfd7078bd386cf"
    static let clientSecret = "7a5b7b8cdc134a58bea4ef1ac5bab083"
    static let state = UUID().uuidString
}

enum Scope: String, CaseIterable {
	case taskAdd = "task:add"
	case dataRead = "data:read"
	case dataWrite = "data:read_write"
	case dataDelete = "data:delete"
	case projectDelete = "project:delete"

	var allPermissions: String {
		""
	}
}

enum ValidAuthURLParams: String {
    case code
    case state
}

final class AuthURLBuilder {
    
    private enum URLCompConst {
        static let clientSecret = "client_secret"
        static let clientId     = "client_id"
        static let scope        = "scope"
        static let state        = "state"
        static let code         = "code"
    }
    
    private static let scheme    = "https"
    private static let host      = "todoist.com"
    private static let authPath  = "/oauth/authorize"
    private static let tokenPath = "/oauth/access_token"
    
    private var clientSecret = AuthRequestConsts.clientSecret
    private var clientId = AuthRequestConsts.clientId
    private var scope    = ""
    private var state    = ""
    private var code     = ""
    
    func state(_ state: String) -> AuthURLBuilder {
        self.state = state
        return self
    }

    func scope(_ scope: [Scope]) -> AuthURLBuilder {
        self.scope = scope.map { $0.rawValue }.joined(separator: ",")
        return self
    }
    
    func code(_ code: String) -> AuthURLBuilder {
        self.code = code
        return self
    }
    
    func buildAuthCodeRequestURL() -> URL? {
        var components = URLComponents()
        components.scheme = AuthURLBuilder.scheme
        components.host = AuthURLBuilder.host
        components.path = AuthURLBuilder.authPath
        let items: [(name: String, value: String)] = [(URLCompConst.clientId, clientId),
                                                      (URLCompConst.scope, scope),
                                                      (URLCompConst.state, state)]
        components.queryItems = items.map { URLQueryItem(name: $0.name, value: $0.value) }
        return components.url
    }
    
    func buildTokenRequestURL() -> URL? {
        var components = URLComponents()
        components.scheme = AuthURLBuilder.scheme
        components.host = AuthURLBuilder.host
        components.path = AuthURLBuilder.tokenPath
        let items: [(name: String, value: String)] = [(URLCompConst.clientId, clientId),
                                                      (URLCompConst.clientSecret, clientSecret),
                                                      (URLCompConst.code, code)]
        components.queryItems = items.map { URLQueryItem(name: $0.name, value: $0.value) }
        return components.url
    }
    
}
