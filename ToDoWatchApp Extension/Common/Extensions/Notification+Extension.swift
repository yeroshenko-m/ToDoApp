//
//  Notification+Extension.swift
//  ToDoWatchApp Extension
//
//  Created by Mykhailo Yeroshenko on 11.04.2021.
//

import Foundation

extension Notification.Name {
	static let StorageDataDidChange: Notification.Name = .init(rawValue: "StorageDataDidChange")
	static let UserLoggedOut: Notification.Name = .init("NotLoggedIn")
	static let UserLoggedIn: Notification.Name = .init("LoggedIn")
}
