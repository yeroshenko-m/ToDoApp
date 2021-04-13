//
//  DatePickerPresenterImpl.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 07.03.2021.
//

import Foundation

// MARK: - Protocol

protocol DatePickerPresenter {
	func present(result: Result<Void, DatePickerError>)
}

// MARK: - Presenter

final class DatePickerPresenterImpl {

	// MARK: - Properties

	private weak var view: DatePickerView?

	// MARK: - Init

	init(view: DatePickerView) {
		self.view = view
	}

}

// MARK: - Presentation logic

extension DatePickerPresenterImpl: DatePickerPresenter {

	func present(result: Result<Void, DatePickerError>) {
		switch result {
		case .failure(let error):
			view?.display(error: error)
			view?.displayDatePickerFailure()
		case .success:
			view?.displayDatePickerSuccess()
		}
	}

}
