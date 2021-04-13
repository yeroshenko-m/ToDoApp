//
//  Project.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 23.02.2021.
//

import Foundation

struct Project: Equatable,
				Codable,
				ToDoObject {

	let id: Int
	let name: String

	let color: Int
	let favorite: Bool
	
}
