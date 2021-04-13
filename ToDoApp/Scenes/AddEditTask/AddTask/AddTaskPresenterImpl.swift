//
//  AddTaskPresenterImpl.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 08.03.2021.
//

import Foundation

// MARK: - Protocol

protocol AddTaskPresenter {
	func present(result: Result<Void, Error>)
	func presentOfflineError(_ error: ReachabilityError, message: String)
	func presentSpeechAccess(status: SpeechRecognitionAvailability)
	func presentSpeechRecognition(result: Result<String, Error>)
	func presentSpeechRecognition(status: SpeechRecognitionStatus)
}

// MARK: - Presenter

final class AddTaskPresenterImpl {

	// MARK: - Properties

	private weak var view: AddTaskView?

	// MARK: - Init

	init(view: AddTaskView) {
		self.view = view
	}

}

// MARK: - Presentation logic

extension AddTaskPresenterImpl: AddTaskPresenter {

	func present(result: Result<Void, Error>) {
		switch result {
		case .failure(let error):
			view?.display(error: error)
			view?.enableActionButtons()
		case .success:
			view?.displaySuccess()
		}
	}

	func presentOfflineError(_ error: ReachabilityError, message: String) {
		view?.display(error: error,
					  message: message,
					  dismissButtonTitle: R.string.localizable.editProjectScreen_alertOk(),
					  dismissHandler: nil)
	}

	func presentSpeechAccess(status: SpeechRecognitionAvailability) {
		switch status {
		case .allowed:
			return
		default:
			view?.display(error: SpeechRecognitionError.recognitionIsNotAvailable)
		}
	}

	func presentSpeechRecognition(result: Result<String, Error>) {
		switch result {
		case .failure(let error):
			view?.display(error: error)
		case .success(let text):
			view?.displayRecognized(text: text)
		}
	}

	func presentSpeechRecognition(status: SpeechRecognitionStatus) {
		view?.displayRecognition(status: status)
	}

}
