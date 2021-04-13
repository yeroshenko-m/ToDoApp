//
//  ReachabilityError.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 04.04.2021.
//

import Foundation

enum ReachabilityError: LocalizedError {
	case deviceOffline

	var errorDescription: String? {
		switch self {
		case .deviceOffline:
			return R.string.localizable.reachability_offlineTitle()
		}
	}
}
