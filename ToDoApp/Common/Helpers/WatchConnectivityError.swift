//
//  WatchConnectivityError.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 09.04.2021.
//

import Foundation

enum WatchConnectivityError: LocalizedError {
	case dataEncodingFailed,
		 contextUpdatingFailed

	var errorDescription: String? {
		switch self {
		case .dataEncodingFailed:
			return R.string.localizable.watchSession_encodingFailed()
		case .contextUpdatingFailed:
			return R.string.localizable.watchSession_contextUpdatingFailed()
		}
	}
}
