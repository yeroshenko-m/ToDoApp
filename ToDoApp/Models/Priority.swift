//
//  Priority.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 02.02.2021.
//

import UIKit

enum Priority: Int, CaseIterable {

	case low = 1
	case normal = 2
	case high = 3
	case urgent = 4

	var description: String {
		switch self {
		case .low: return R.string.localizable.priority_low()
		case .normal: return R.string.localizable.priority_normal()
		case .high: return R.string.localizable.priority_high()
		case .urgent: return R.string.localizable.priority_urgent()
		}
	}

	var color: UIColor {
		switch self {
		case .low: 		return R.color.defaultPriority() ?? .systemGray4
		case .normal:	return .systemBlue
		case .high: 	return .systemOrange
		case .urgent: 	return .systemRed
		}
	}

	init(rawValue: Int) {
		switch rawValue {
		case 1: self = .low
		case 2: self = .normal
		case 3: self = .high
		case 4: self = .urgent
		default: self = .low
		}
	}
	
}
