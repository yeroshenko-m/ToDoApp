//
//  TokenStorage.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 20.01.2021.
//

import KeychainSwift

final class TokenStorageManager {

    private let storageKey = "Authorization token"
    private let storage = KeychainSwift.init(keyPrefix: "ToDoApp_")
    
    func getToken() -> Token? {
        guard
            let tokenData = storage.getData(storageKey),
            let token = try? JSONDecoder().decode(Token.self, from: tokenData)
        else { return nil }
        return token
    }
    
    func save(token: Token) {
        if let tokenData = try? JSONEncoder().encode(token),
           storage.set(tokenData, forKey: storageKey, withAccess: .accessibleWhenUnlocked) {
        }
    }
    
	func deleteToken(completion: @escaping VoidResultCompletion) {
        let tokenDeleted = storage.delete(storageKey)
		if tokenDeleted {
			completion(.success(()))
		} else {
			completion(.failure(TokenStorageError.tokenDeletionFailed))
		}
    }

}
