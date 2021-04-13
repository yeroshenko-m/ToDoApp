//
//  DateFormatterRFC339.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 22.02.2021.
//

import Foundation

extension DateFormatter {

	func dateFromRFC3339String(_ string: String?) -> Date? {
		dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
		if let dateString = string {
			return date(from: dateString)
		} else {
			return nil
		}

	}

	func stringRFC3339FromDate(_ date: Date) -> String {
		dateFormat = "yyyy'-'MM'-'dd'T'HH':'mm':'ss'Z'"
		return string(from: date)
	}

	func shortRFC3339StringFrom(date: Date) -> String {
		dateFormat = "yyyy'-'MM'-'dd"
		return string(from: date)
	}

	func dateTimeString(from date: Date?) -> String? {
		dateStyle = .short
		timeStyle = .short
		if let dateToDisplay = date {
			return string(from: dateToDisplay)
		} else {
			return nil
		}
	}

	func dateTimeString(from RFC3339string: String?) -> String? {
		guard let date = dateFromRFC3339String(RFC3339string)
		else { return nil }
		dateStyle = .short
		timeStyle = .short
		return string(from: date)
	}

	func sectionDateString(from dateString: String?) -> String? {
		guard let dateString = dateString,
			  let date = dateFromRFC3339String(dateString)
		else { return nil }

		dateFormat = "EE"
		let weekDay = string(from: date)
		let shortString = shortRFC3339StringFrom(date: date)

		return "\(weekDay), \(shortString)"
	}

}
