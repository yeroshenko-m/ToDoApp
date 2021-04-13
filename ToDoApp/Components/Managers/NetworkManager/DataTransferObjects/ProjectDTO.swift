//
//  Project.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 26.01.2021.
//

import Foundation

struct ProjectDTO: Codable,
				   Hashable,
				   DataTransferObject {

    let id: Int
    let color: Int
    let name: String
    let favorite: Bool

}
