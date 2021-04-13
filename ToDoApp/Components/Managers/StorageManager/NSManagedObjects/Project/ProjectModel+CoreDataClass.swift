//
//  ProjectModel+CoreDataClass.swift
//  
//
//  Created by Mykhailo Yeroshenko on 10.03.2021.
//
//

import CoreData

@objc(ProjectModel)
public class ProjectModel: NSManagedObject {

	var asProject: Project {
		Project(id: Int(identifier),
				name: name ?? "Undefined name",
				color: Int(color),
				favorite: favorite)
	}

}

extension ProjectModel: DTOConfigurable {

	func hasDifferences<Object: DataTransferObject>(from object: Object) throws -> Bool {
		guard let projectDTO = object as? ProjectDTO else { throw DTOCastingError.objectTypeMismatch }
		if projectDTO.favorite == favorite,
		   projectDTO.color == color,
		   projectDTO.id == identifier,
		   projectDTO.name == name {
			return false
		}
		return true
	}

	func configure<Object: DataTransferObject>(withObject object: Object) {
		guard let project = object as? ProjectDTO else { return }
		color = .init(clamping: project.color)
		favorite = project.favorite
		identifier = .init(clamping: project.id)
		name = project.name
	}

	func update(withObject object: ToDoObject) {
		guard let project = object as? Project else { return }
		name = project.name
		color = Int16(project.color)
		favorite = project.favorite
	}
	
}
