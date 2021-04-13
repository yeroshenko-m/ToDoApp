//
//  Reachability.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 23.03.2021.
//

import Reachability

final class ReachabilityManager {

	// MARK: - Singleton

	static let shared = ReachabilityManager()

	// MARK: - Private properties

	private let reachability = try! Reachability()
	
	// MARK: - Public properties

	var connectionType: Reachability.Connection {
		reachability.connection
	}

	var isReachable: Bool {
		connectionType != .unavailable
	}

	var isUnreachable: Bool {
		connectionType == .unavailable
	}

	// MARK: - Init

	private init() {
		try? reachability.startNotifier()
	}

}
