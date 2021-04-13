//
//  Project POST parameters.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 28.01.2021.
//

import Foundation

struct ProjectRequestParams: Encodable {

    let name: String
    let favorite: Bool
    let color: Int

	init(project: Project) {
		name = project.name
		favorite = project.favorite
		color = project.color
	}

}
