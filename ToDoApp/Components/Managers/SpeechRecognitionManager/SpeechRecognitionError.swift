//
//  SpeechRecognitionError.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 02.04.2021.
//

import Foundation

enum SpeechRecognitionError: LocalizedError {
	case recognitionIsNotAvailable

	var errorDescription: String? {
		switch self {
		case .recognitionIsNotAvailable:
			return "SpeechRecognition is not available right now"
		}
	}
}
