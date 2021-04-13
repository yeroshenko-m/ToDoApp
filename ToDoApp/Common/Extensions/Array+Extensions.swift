//
//  Array+Extensions.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 22.02.2021.
//

import Foundation

extension Array where Element == Int64 {

	init(arrayOfInts: [Int]) {
		var arrayOfInts64 = [Int64]()
		arrayOfInts.forEach({ arrayOfInts64.append(.init(clamping: $0)) })
		self = arrayOfInts64
	}
	
}

extension Array where Element: Equatable {

	mutating func removeDuplicates() {
		var result = [Element]()
		for value in self {
			if !result.contains(value) {
				result.append(value)
			}
		}
		self = result
	}
	
}

extension Array where Element: Hashable {
	
	func difference(from other: [Element]) -> [Element] {
		let thisSet = Set(self)
		let otherSet = Set(other)
		return Array(thisSet.symmetricDifference(otherSet))
	}
	
}

extension Array where Element == TasksListSection {

	var allSectionsAreEmpty: Bool {
		for element in self {
			if element.tasks.isEmpty {
				continue
			} else {
				return false
			}
		}
		return true
	}

}
