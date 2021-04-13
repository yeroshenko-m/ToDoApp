//
//  TasksServiceDelegateProtocol.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 11.04.2021.
//

import Foundation

protocol TasksServiceDelegate: class {
	func onStorageChange()
}
