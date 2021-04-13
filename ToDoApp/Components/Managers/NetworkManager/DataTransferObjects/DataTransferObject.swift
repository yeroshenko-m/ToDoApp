//
//  DataTransferObjectProtocol.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 23.02.2021.
//

import Foundation

protocol DataTransferObject: Hashable {
	var id: Int { get }
}

func sort<DTO: DataTransferObject, Model: DTOConfigurable>(dataTransferObjects: [DTO],
														   cachedModels: [Model]) throws -> SortedObjects<DTO, Model> {
	// Task DTOs to be saved to storage
	var newDTO: [DTO] = []
	// Stored task models, which need to be updated with appropriate DTO
	var updatedDTO: [DTO] = []
	var modelsToUpdate: [Model] = []
	// Task DTOs, that have same data as already stored models
	var existingNotUpdatedDTO: [DTO] = []

	for object in dataTransferObjects {
		for model in cachedModels {
			if object.id == Int(model.identifier) {
				if try model.hasDifferences(from: object) {
					updatedDTO.append(object)
					modelsToUpdate.append(model)
				} else {
					existingNotUpdatedDTO.append(object)
				}
			}
		}
	}

	newDTO = dataTransferObjects
		.difference(from: updatedDTO)
		.difference(from: existingNotUpdatedDTO)

	return .init(newDTO: newDTO,
				 updatedDTO: updatedDTO,
				 modelsToUpdate: modelsToUpdate,
				 existingNotUpdatedDTO: existingNotUpdatedDTO)
}
