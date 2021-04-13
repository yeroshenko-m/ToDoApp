//
//  UpdatableWithTaskInfoProtocol.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 04.04.2021.
//

import Foundation

protocol UpdatableWithTaskInfo {
	func setDate(_ date: Date?)
	func setProject(_ project: Project?)
	func setPriority(_ priority: Priority)
}

extension UpdatableWithTaskInfo {
	func setProject(_ project: Project?) {}
}
