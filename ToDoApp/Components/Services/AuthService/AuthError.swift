//
//  AuthServiceError.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 04.04.2021.
//

import Foundation

enum AuthError: LocalizedError {
	case notValidURL
	case emptyTokenExchangeDataResponse
	case invalidGrant
}

extension AuthError {
	var errorDescription: String {
		switch self {
		case .notValidURL:
			return R.string.localizable.authError_notValidUrl()
		case .emptyTokenExchangeDataResponse:
			return R.string.localizable.authError_emptyToken()
		case .invalidGrant:
			return R.string.localizable.authError_invalidGrands()
		}
	}
}
