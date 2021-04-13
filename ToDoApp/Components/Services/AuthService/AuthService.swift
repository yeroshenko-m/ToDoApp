//
//  AuthorizationService.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 20.01.2021.
//

import Foundation

final class AuthService: AuthServiceProtocol {

	// MARK: - NotificationCenterMessage

	static let logoutNotificationName = NSNotification.Name("LogOut")
	static let loginNotificationName = NSNotification.Name("LogIn")
	private let notificationCenter = NotificationCenter.default

	// MARK: - Properties
    
    private let tokenStorage = TokenStorageManager()
	private let networkManager = NetworkManager.shared
    private let accessTokenURL = AuthURLBuilder().buildTokenRequestURL()
    
    var codeRequestURL: URL? {
        AuthURLBuilder()
            .scope([.taskAdd, .dataWrite, .dataDelete, .projectDelete])
            .state(AuthRequestConsts.state)
            .buildAuthCodeRequestURL()
    }
    
    var isAuthorized: Bool {
		(tokenStorage.getToken() != nil)
	}
    
    var authTokenString: String? {
		tokenStorage.getToken()?.description
	}

	// MARK: - Methods
    
    func isRedirectURLValid(_ url: URL) -> Bool {
        guard let comps = URLComponents(string: url.absoluteString),
              let queryItems = comps.queryItems
        else { return false }
        return queryItems.contains(where: {$0.name == ValidAuthURLParams.code.rawValue }) &&
            queryItems.contains(where: { $0.name == ValidAuthURLParams.state.rawValue && $0.value == AuthRequestConsts.state })
            ? true : false
    }
    
    func fetchCodeFromURL(_ url: URL) -> String? {
        guard let components = NSURLComponents(url: url, resolvingAgainstBaseURL: false),
              let queryItems = components.queryItems
        else { return nil }
        return queryItems.filter({ $0.name == ValidAuthURLParams.code.rawValue }).first?.value
    }
    
	func fetchToken(withCode code: String,
					completion: @escaping AuthVoidResultCompletion) {
		let requestParams = AuthTokenRequestParams(clientId: AuthRequestConsts.clientId,
												   clientSecret: AuthRequestConsts.clientSecret,
												   code: code,
												   redirectUrl: AuthRequestConsts.redirectURL)

		networkManager.call(type: EndPointType.token(clientId: AuthRequestConsts.clientId,
														secret: AuthRequestConsts.clientSecret,
														code: code,
														redirectURL: AuthRequestConsts.redirectURL),
							params: requestParams) { (result: Result<Token, Error>) in
			switch result {
			case .failure:
				completion(.failure(.emptyTokenExchangeDataResponse))
			case .success(let token):
				self.tokenStorage.save(token: token)
				completion(.success(()))
				self.notificationCenter.post(name: AuthService.loginNotificationName, object: nil)
			}
		}
    }
    
    func logOut(completion: @escaping VoidResultCompletion) {
		tokenStorage.deleteToken { result in
			switch result {
			case .failure(let error):
				completion(.failure(error))
			case .success:
				self.notificationCenter.post(name: AuthService.logoutNotificationName, object: nil)
				completion(.success(()))
			}
		}
	}
    
}
