//
//  NSmanagedObject+Extension.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 23.02.2021.
//

import CoreData

extension NSManagedObject {
	
	static var entityName: String { return String(describing: Self.self) }
	
}
