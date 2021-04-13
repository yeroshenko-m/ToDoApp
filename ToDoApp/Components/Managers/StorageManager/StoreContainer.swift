//
//  StoreContainer.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 25.02.2021.
//

import CoreData

final class StoreContainer {

	private init() {}

	private static let modelName = "ToDoApp"

	static let container: NSPersistentContainer = {
		let container = NSPersistentContainer(name: modelName)
		container.loadPersistentStores { _, error in
			if let error = error as NSError? {
				print("Unresolved error \(error), \(error.userInfo)")
			}
		}
		return container
	}()

}
