//
//  DatePickerInteractorImpl.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 07.03.2021.
//

import Foundation

// MARK: - Protocol

protocol DatePickerInteractor {
	func checkDateValidity(_ date: Date)
}

// MARK: - Interactor

final class DatePickerInteractorImpl {

	// MARK: - Properties

	private let presenter: DatePickerPresenter
	private let currentDateTime = Date(timeIntervalSinceNow: -86400)

	// MARK: - Init

	init(presenter: DatePickerPresenter) {
		self.presenter = presenter
	}

}

// MARK: - Business logic

extension DatePickerInteractorImpl: DatePickerInteractor {

	func checkDateValidity(_ date: Date) {
		if date < currentDateTime {
			presenter.present(result: .failure(DatePickerError.invalidDate))
		} else {
			presenter.present(result: .success(()))
		}
	}
	
}

enum DatePickerError: LocalizedError {
	case invalidDate

	var errorDescription: String? {
		R.string.localizable.datepickerController_estimatingAlertTitle()
	}
}

extension DatePickerError {

}
