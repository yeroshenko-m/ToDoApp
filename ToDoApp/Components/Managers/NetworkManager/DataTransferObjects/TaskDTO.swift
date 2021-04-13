//
//  Task.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 02.02.2021.
//

import Foundation

struct TaskDTO: Codable,
				Hashable,
				DataTransferObject {

    let id: Int
    let projectId: Int
    let content: String
    let completed: Bool
	let created: String
    let due: TaskDueDate?
    let priority: Int
    let url: String

    enum CodingKeys: String, CodingKey {
        case id, content, completed, priority, url, due, created
        case projectId = "project_id"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(Int.self, forKey: .id)
        projectId = try container.decode(Int.self, forKey: .projectId)
        content = try container.decode(String.self, forKey: .content)
        completed = try container.decode(Bool.self, forKey: .completed)
		created = try container.decode(String.self, forKey: .created)
        due = try? container.decode(TaskDueDate.self, forKey: .due)
        priority = try container.decode(Int.self, forKey: .priority)
        url = try container.decode(String.self, forKey: .url)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(CodingKeys.id.rawValue, forKey: .id)
        try container.encode(CodingKeys.projectId.rawValue, forKey: .projectId)
        try container.encode(CodingKeys.content.rawValue, forKey: .content)
        try container.encode(CodingKeys.completed.rawValue, forKey: .completed)
		try container.encode(CodingKeys.created.rawValue, forKey: .created)
        try container.encode(CodingKeys.due.rawValue, forKey: .due)
        try container.encode(CodingKeys.priority.rawValue, forKey: .priority)
        try container.encode(CodingKeys.url.rawValue, forKey: .url)
    }
    
}
