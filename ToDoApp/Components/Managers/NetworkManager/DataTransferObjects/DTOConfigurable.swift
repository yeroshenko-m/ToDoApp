//
//  DTOConfigurableProtocol.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 23.02.2021.
//

import Foundation

protocol DTOConfigurable {
	var identifier: Int64 { get set }

	func configure<Object: DataTransferObject>(withObject object: Object)
	func update(withObject object: ToDoObject)
	func hasDifferences<Object: DataTransferObject>(from object: Object) throws -> Bool
}
