//
//  SpeechRecognitionAvailability.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 02.04.2021.
//

import Foundation

enum SpeechRecognitionAvailability {
	case allowed, denied, restricted, notDetermined, notAvailable

	var description: String {
		switch self {
		case .allowed: return "User allowed access to speech recognition"
		case .denied: return "User denied access to speech recognition"
		case .notDetermined: return "Speech recognition not yet authorized"
		case .restricted: return "Speech recognition restricted on this device"
		case .notAvailable: return "Speech recognition is not available"
		}
	}
}
