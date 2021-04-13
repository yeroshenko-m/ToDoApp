//
//  File.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 09.02.2021.
//

import Foundation

struct TaskDueDate: Codable, Hashable {

    let recurring: Bool
    let string: String
    let date: String
    let datetime: String
    let timezone: String
    
    enum CodingKeys: String, CodingKey {
        case recurring, string, date, datetime, timezone
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
		
        recurring = try container.decode(Bool.self, forKey: .recurring)
        string = try container.decode(String.self, forKey: .string)
        date = try container.decode(String.self, forKey: .date)
        datetime = try container.decode(String.self, forKey: .datetime)
        timezone = try container.decode(String.self, forKey: .timezone)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
		
        try container.encode(CodingKeys.recurring.rawValue, forKey: .recurring)
        try container.encode(CodingKeys.string.rawValue, forKey: .string)
        try container.encode(CodingKeys.date.rawValue, forKey: .date)
        try container.encode(CodingKeys.datetime.rawValue, forKey: .datetime)
        try container.encode(CodingKeys.timezone.rawValue, forKey: .timezone)
    }

}
