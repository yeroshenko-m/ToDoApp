//
//  MulticastDelegate.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 11.04.2021.
//

import Foundation

final class MulticastDelegate<T> {

	private let delegates: NSHashTable<AnyObject> = NSHashTable.weakObjects()

	func add(_ delegate: T) {
		delegates.add(delegate as AnyObject)
	}

	func remove(_ delegateToRemove: T) {
		for delegate in delegates.allObjects.reversed()
			where delegate === delegateToRemove as AnyObject {
				delegates.remove(delegate)
		}
	}

	func invoke(_ invocation: (T) -> Void) {
		for delegate in delegates.allObjects.reversed() {
			invocation(delegate as! T)
		}
	}
	
}
