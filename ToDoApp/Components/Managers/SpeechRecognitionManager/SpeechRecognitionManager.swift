//
//  SpeechRecognitionManager.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 01.04.2021.
//

import Speech

final class SpeechRecognitionManager {

	// MARK: - External properties

	weak var delegate: SFSpeechRecognizerDelegate? {
		didSet {
			setupSpeechRecognizerDelegate(delegate)
		}
	}

	private(set) var isRecognizing = false

	// MARK: - Internal properties

	private let audioEngine: AVAudioEngine
	private let audioSession: AVAudioSession
	private var speechRecognizer: SFSpeechRecognizer?

	private var request: SFSpeechAudioBufferRecognitionRequest?
	private var recognitionTask: SFSpeechRecognitionTask?

	private let audioNodeBus: AVAudioNodeBus = .zero
	private let audioFrameCount: AVAudioFrameCount = 1024

	// MARK: - Init

	init(engine: AVAudioEngine,
		 session: AVAudioSession,
		 recognizer: SFSpeechRecognizer?) {
		audioEngine = engine
		audioSession = session
		speechRecognizer = recognizer
	}

	// MARK: - Public API

	func requestSpeechRecognitionAccess(completion: @escaping (SpeechRecognitionAvailability) -> Void) {
		SFSpeechRecognizer.requestAuthorization { authStatus in
			let status: SpeechRecognitionAvailability
			switch authStatus {
			case .authorized: status = .allowed
			case .denied: status = .denied
			case .restricted: status = .restricted
			case .notDetermined: status = .notDetermined
			default: status = .notAvailable
			}
			completion(status)
		}
	}

	func startRecognition(recognizedTextHandler: @escaping (String) -> Void) throws {
		recognitionTask?.cancel()
		recognitionTask = nil

		try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
		try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
		let inputNode = audioEngine.inputNode

		request = SFSpeechAudioBufferRecognitionRequest()
		guard let recognitionRequest = request
		else { fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object") }

		recognitionRequest.shouldReportPartialResults = true

		if #available(iOS 13, *) {
			recognitionRequest.requiresOnDeviceRecognition = false
		}

		recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
			var isFinal = false

			if let result = result {
				recognizedTextHandler(result.bestTranscription.formattedString)
				isFinal = result.isFinal
			}

			if error != nil || isFinal {
				self.isRecognizing = false
				self.audioEngine.stop()
				inputNode.removeTap(onBus: self.audioNodeBus)
				self.request = nil
				self.recognitionTask = nil
			}
		}

		let recordingFormat = inputNode.outputFormat(forBus: audioNodeBus)
		inputNode.installTap(onBus: audioNodeBus,
							 bufferSize: audioFrameCount,
							 format: recordingFormat) { buffer, _ in
			self.request?.append(buffer)
		}

		audioEngine.prepare()
		try audioEngine.start()
		isRecognizing = true

	}

	func stopRecognition() {
		audioEngine.stop()
		audioEngine.inputNode.removeTap(onBus: self.audioNodeBus)
		request?.endAudio()
		recognitionTask?.cancel()
		recognitionTask = nil
		isRecognizing = false
	}

	// MARK: - Private methods

	private func setupSpeechRecognizerDelegate(_ delegate: SFSpeechRecognizerDelegate?) {
		if let recognizerDelegate = delegate {
			speechRecognizer?.delegate = recognizerDelegate
		} else {
			speechRecognizer?.delegate = nil
		}
	}

}
