//
//  TextFieldCell.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 25.01.2021.
//

import UIKit

protocol TextFieldCellDelegate: class {
	var onSpeechRecognitionStartAction: (() -> Void)? { get set }
	var onSpeechRecognitionStopAction: (() -> Void)? { get set }
	func textChanged(to text: String)
	func speechButtonPressed(on cell: TextFieldCell)
}

final class TextFieldCell: UITableViewCell {

	private lazy var pulsator = { () -> Pulsing in
		let pulsator = Pulsing(numberOfPulses: .infinity,
							   radius: speechButton.frame.height * 0.8,
							   position: speechButton.center)
		layer.insertSublayer(pulsator, below: speechButton.layer)
		pulsator.isHidden = true
		return pulsator
	}()

	// MARK: - Properties

	weak var delegate: TextFieldCellDelegate? {
		didSet {
			configureDelegateActions()
		}
	}

	// MARK: - IBOutlets

	@IBOutlet weak var textField: UITextField! {
		didSet {
			textField.delegate = self
		}
	}

	@IBOutlet weak var speechButton: SpeechRecordButton!

	// MARK: - IBActions

	@IBAction func textFieldActionDidEndEditing(_ sender: UITextField) {
		if let text = textField.text {
			delegate?.textChanged(to: text)
		}
	}

	@IBAction func speechButtonPressed(_ sender: SpeechRecordButton) {
		delegate?.speechButtonPressed(on: self)
	}

	// MARK: - Cell lifecycle

	override func layoutSubviews() {
		super.layoutSubviews()
		backgroundColor = R.color.cellsColor()
	}

	// MARK: - API

	// TODO: implement better mechanism for disabling 'pulsator' layer, not using 'isHidden'
	private func startPulsatorAnimation() {
		pulsator.isHidden = false
	}

	private func stopPulsatorAnimation() {
		pulsator.isHidden = true
	}

	// MARK: - Config

	private func configureDelegateActions() {
		delegate?.onSpeechRecognitionStartAction = { [weak self] in
			self?.startPulsatorAnimation()
		}

		delegate?.onSpeechRecognitionStopAction = { [weak self] in
			self?.stopPulsatorAnimation()
		}
	}

}

// MARK: - TextFieldCell+Delegate

extension TextFieldCell: UITextFieldDelegate {

	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		endEditing(true)
		return true
	}

}
