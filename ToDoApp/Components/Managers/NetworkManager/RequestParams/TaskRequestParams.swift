//
//  Project POST parameters.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 28.01.2021.
//

import Foundation

struct TaskRequestParams: Encodable {
	
    let projectId: Int
    let content: String
    let dueDateTime: String?
    let priority: Int

	init(task: Task) {
		self.projectId = task.projectId
		self.content = task.name
		self.dueDateTime = task.due
		self.priority = task.priority
	}
    
    enum CodingKeys: String, CodingKey {
        case content, priority
        case projectId = "project_id"
        case dueDateTime = "due_datetime"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
		
        try container.encode(projectId, forKey: .projectId)
        try container.encode(content, forKey: .content)
        try container.encode(dueDateTime, forKey: .dueDateTime)
        try container.encode(priority, forKey: .priority)

    }
	
}
