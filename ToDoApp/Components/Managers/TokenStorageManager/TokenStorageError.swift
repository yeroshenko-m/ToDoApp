//
//  TokenStorageError.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 04.04.2021.
//

import Foundation

enum TokenStorageError: LocalizedError {

	case tokenDeletionFailed

	var errorDescription: String? {
		switch self {
		case .tokenDeletionFailed:
			return "Can't delete user token. Try later"
		}
	}
}
