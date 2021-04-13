//
//  AuthServiceProtocol.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 24.02.2021.
//

import Foundation

protocol AuthServiceProtocol {

	var isAuthorized: Bool { get }
	var codeRequestURL: URL? { get }
	var authTokenString: String? { get }

	func isRedirectURLValid(_ url: URL) -> Bool
	func fetchCodeFromURL(_ url: URL) -> String?
	func fetchToken(withCode code: String,
					completion: @escaping AuthVoidResultCompletion)
}
