//
//  AddTaskInteractorImpl.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 08.03.2021.
//

import AVFoundation
import Speech

// MARK: - Protocol

protocol AddTaskInteractor {
	var isRecognizingSpeech: Bool { get }
	func makeNew(task: Task)
	func startSpeechRecognition()
	func stopSpeechRecognition()
}

// MARK: - Interactor

final class AddTaskInteractorImpl {

	// MARK: - Properties

	private let presenter: AddTaskPresenter
	private let tasksService: TasksService
	private let reachabilityManager: ReachabilityManager
	private let speechManager: SpeechRecognitionManager?

	// MARK: - Init

	init(presenter: AddTaskPresenter,
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

extension AddTaskInteractorImpl: AddTaskInteractor {

	var isRecognizingSpeech: Bool {
		speechManager?.isRecognizing ?? false
	}

	func makeNew(task: Task) {
		guard reachabilityManager.isReachable else {
			presenter.presentOfflineError(.deviceOffline, message: R.string.localizable.reachability_addTask())
			return
		}
		tasksService.makeNewTask(task) { result in
			self.presenter.present(result: result)
		}
	}

	func startSpeechRecognition() {
		guard SFSpeechRecognizer.authorizationStatus() == .authorized else {
			requestSpeechAccess()
			return
		}
		do {
			presenter.presentSpeechRecognition(status: .inProgress)
			try self.speechManager?.startRecognition(recognizedTextHandler: { text in
				self.presenter.presentSpeechRecognition(result: .success(text))
			})
		} catch let error as NSError {
			presenter.presentSpeechRecognition(result: .failure(error))
		}

	}

	func stopSpeechRecognition() {
		presenter.presentSpeechRecognition(status: .isFinished)
		speechManager?.stopRecognition()
	}

	// MARK: - Private methods

	private func requestSpeechAccess() {
		speechManager?.requestSpeechRecognitionAccess { status in
			self.presenter.presentSpeechAccess(status: status)
		}
	}

}
