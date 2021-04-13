//
//  Date+Extension.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 10.04.2021.
//

import Foundation

extension Date {

	func daysOfWeek(using calendar: Calendar = .init(identifier: .gregorian)) -> [Date] {
		let startOfWeek = self.startOfWeek(using: calendar).noon
		return (0...6).map { startOfWeek.byAdding(component: .day,
												  value: $0,
												  using: calendar)! }
	}

	// MARK: - Private

	private func byAdding(component: Calendar.Component,
						  value: Int,
						  wrappingComponents: Bool = false,
						  using calendar: Calendar = .current) -> Date? {
		calendar.date(byAdding: component,
					  value: value,
					  to: self,
					  wrappingComponents: wrappingComponents)
	}

	private func dateComponents(_ components: Set<Calendar.Component>,
								using calendar: Calendar = .current) -> DateComponents {
		calendar.dateComponents(components, from: self)
	}

	private func startOfWeek(using calendar: Calendar = .current) -> Date {
		Date()
	}

	private var noon: Date {
		Calendar.current.date(bySettingHour: 12,
							  minute: 0,
							  second: 0, of: self)!
	}

}
