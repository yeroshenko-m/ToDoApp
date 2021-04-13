//
//  DTOCastingError.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 04.04.2021.
//

import Foundation

enum DTOCastingError: LocalizedError {
	case objectTypeMismatch

	var errorDescription: String? {
		"Can not save data from server, because it has wrong type"
	}
}
