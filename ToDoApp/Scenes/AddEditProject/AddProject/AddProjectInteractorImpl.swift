//
//  AddProjectInteractorImpl.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 09.03.2021.
//

import AVFoundation
import Speech

// MARK: - Protocol

protocol AddProjectInteractor {
	var isRecognizingSpeech: Bool { get }
	func makeNew(project: Project)
	func startSpeechRecognition()
	func stopSpeechRecognition()
}

// MARK: - Interactor

final class AddProjectInteractorImpl {

	// MARK: - Properties

	private let presenter: AddProjectPresenter
	private let projectsService: ProjectsService
	private let reachabilityManager: ReachabilityManager
	private let speechManager: SpeechRecognitionManager?

	// MARK: - Init

	init(presenter: AddProjectPresenter,
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

extension AddProjectInteractorImpl: AddProjectInteractor {

	var isRecognizingSpeech: Bool {
		return speechManager?.isRecognizing ?? false
	}

	func makeNew(project: Project) {
		guard reachabilityManager.isReachable else {
			presenter.presentOfflineError(.deviceOffline, message: R.string.localizable.reachability_addProject())
			return
		}
		projectsService.makeNewProject(project) { result in
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
			self.presenter.presentSpeechRecognition(status: .inProgress)
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
