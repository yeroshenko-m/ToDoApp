//
//  TaskModel.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 23.02.2021.
//

import Foundation

struct Task: Equatable,
			 Codable,
			 ToDoObject {

	let id: Int
	let name: String

	let projectId: Int
	let created: String
	let due: String?
	let priority: Int

	let projectName: String

}

extension Task {

	var isOutdated: Bool {
		guard let taskDate = DateFormatter().dateFromRFC3339String(due) else {
			return false
		}
		return Date() > taskDate
	}
	
}
