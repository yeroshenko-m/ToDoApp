//
//  Token.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 20.01.2021.
//

import Foundation

struct Token: Codable, CustomStringConvertible {

	let type: String
	let value: String

	var description: String {
		"\(type) \(value)"
	}

	enum CodingKeys: String, CodingKey {
		case type = "token_type"
		case value = "access_token"
	}

	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)

		type = try container.decode(String.self, forKey: .type)
		value = try container.decode(String.self, forKey: .value)
	}

	func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		
		try container.encode(type, forKey: .type)
		try container.encode(value, forKey: .value)
	}

}
