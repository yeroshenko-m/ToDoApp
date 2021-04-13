//
//  EditTaskInteractorImpl.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 09.03.2021.
//

import AVFoundation
import Speech

// MARK: - Protocol

protocol EditTaskInteractor {
	var isRecognizingSpeech: Bool { get }
	func update(task: Task)
	func delete(task: Task)
	func startSpeechRecognition()
	func stopSpeechRecognition()
}

// MARK: - Interactor

final class EditTaskInteractorImpl {

	// MARK: - Properties

	private var presenter: EditTaskPresenter
	private let tasksService: TasksService
	private let reachabilityManager: ReachabilityManager
	private let speechManager: SpeechRecognitionManager?

	// MARK: - Init

	init(presenter: EditTaskPresenter,
		 tasksService: TasksService) {
		self.presenter = presenter
		self.tasksService = tasksService
		reachabilityManager = ReachabilityManager.shared
		speechManager = .init(engine: AVAudioEngine(),
							  session: AVAudioSession.sharedInstance(),
							  recognizer: SFSpeechRecognizer())
	}

}

// MARK: - Business logic

extension EditTaskInteractorImpl: EditTaskInteractor {

	var isRecognizingSpeech: Bool {
		speechManager?.isRecognizing ?? false
	}

	func update(task: Task) {
		guard reachabilityManager.isReachable else {
			presenter.presentOfflineError(.deviceOffline, message: R.string.localizable.reachability_editTask())
			return
		}
		tasksService.updateTask(task) { result in
			self.presenter.present(result: result)
		}
	}

	func delete(task: Task) {
		guard reachabilityManager.isReachable else {
			presenter.presentOfflineError(.deviceOffline, message: R.string.localizable.reachability_deleteTask())
			return
		}
		tasksService.deleteTask(task) { result in
			self.presenter.present(result: result)
		}
	}

	func startSpeechRecognition() {
		guard SFSpeechRecognizer.authorizationStatus() == .authorized else {
			requestSpeechAccess()
			return
		}
		do {
			try self.speechManager?.startRecognition(recognizedTextHandler: { text in
				self.presenter.presentSpeechRecognition(result: .success(text))
			})
			presenter.presentSpeechRecognition(status: .inProgress)
		} catch let error as NSError {
			presenter.presentSpeechRecognition(result: .failure(error))
		}

	}

	func stopSpeechRecognition() {
		speechManager?.stopRecognition()
		presenter.presentSpeechRecognition(status: .isFinished)
	}

	// MARK: - Private methods

	private func requestSpeechAccess() {
		speechManager?.requestSpeechRecognitionAccess { status in
			self.presenter.presentSpeechAccess(status: status)
		}
	}

}
