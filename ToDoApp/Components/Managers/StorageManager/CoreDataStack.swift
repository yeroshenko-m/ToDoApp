//
//  CoreDataStack.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 20.02.2021.
//

import CoreData

final class CoreDataStack {

	private let storeContainer: NSPersistentContainer

	init(storeContainer: NSPersistentContainer) {
		self.storeContainer = storeContainer
	}

	lazy var managedContext: NSManagedObjectContext = {
		let context = storeContainer.viewContext
		context.automaticallyMergesChangesFromParent = true
		return context
	}()

	lazy var backgroundContext: NSManagedObjectContext = {
		return storeContainer.newBackgroundContext()
	}()

	func saveContext () {
		guard managedContext.hasChanges
		else { return }
		do {
			try managedContext.save()
		} catch let error as NSError {
			print("Error in managedContext")
			print("Unresolved error \(error), \(error.userInfo)")
		}
	}

}
