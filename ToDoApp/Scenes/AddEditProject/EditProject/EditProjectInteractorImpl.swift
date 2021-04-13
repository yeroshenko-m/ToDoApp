//
//  EditProjectInteractorImpl.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 09.03.2021.
//

import AVFoundation
import Speech

// MARK: - Protocol

protocol EditProjectInteractor {
	var isRecognizingSpeech: Bool { get }
	func update(project: Project)
	func delete(project: Project)
	func startSpeechRecognition()
	func stopSpeechRecognition()
}

// MARK: - Interactor

final class EditProjectInteractorImpl {

	// MARK: - Properties

	private var presenter: EditProjectPresenter
	private let projectsService: ProjectsService
	private let reachabilityManager: ReachabilityManager
	private let speechManager: SpeechRecognitionManager?

	// MARK: - Init

	init(presenter: EditProjectPresenter,
		 projectsService: ProjectsService) {
		self.presenter = presenter
		self.projectsService = projectsService
		reachabilityManager = ReachabilityManager.shared
		speechManager = .init(engine: AVAudioEngine(),
							  session: AVAudioSession.sharedInstance(),
							  recognizer: SFSpeechRecognizer())
	}

}

// MARK: - Business logic

extension EditProjectInteractorImpl: EditProjectInteractor {

	var isRecognizingSpeech: Bool {
		speechManager?.isRecognizing ?? false
	}

	func update(project: Project) {
		guard reachabilityManager.isReachable else {
			presenter.presentOfflineError(.deviceOffline, message: R.string.localizable.reachability_editProject())
			return
		}
		projectsService.updateProject(project) { result in
			self.presenter.present(result: result)
		}
	}

	func delete(project: Project) {
		guard reachabilityManager.isReachable else {
			presenter.presentOfflineError(.deviceOffline, message: R.string.localizable.reachability_deleteProject())
			return
		}
		projectsService.deleteProject(project) { result in
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
