//
//  SpeechRecordButton.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 01.04.2021.
//

import UIKit

private enum Constants {

	enum Shadow {
		static let offset = CGSize(width: 1.5, height: 1.5)
		static let radius: CGFloat = 2.0
		static let opacity: Float = 0.5
	}

	enum Appearance {
		static let tintColor = UIColor.tertiarySystemGroupedBackground
		static let backgroundColor = R.color.iconsTintColor()
		static let image = R.image.mic()?.withRenderingMode(.alwaysTemplate)
		static let cornerMultiplier: CGFloat = 2.0
	}

	enum Frame {
		static let width: CGFloat = 40.0
		static var height: CGFloat { width }
	}

}

final class SpeechRecordButton: UIButton {

	override func layoutSubviews() {
		super.layoutSubviews()
		layer.cornerRadius = frame.height / Constants.Appearance.cornerMultiplier
		layer.shadowOpacity = Constants.Shadow.opacity
		layer.shadowRadius = Constants.Shadow.radius
		layer.shadowOffset = Constants.Shadow.offset
		layer.shadowPath = UIBezierPath(ovalIn: bounds).cgPath
		layer.shouldRasterize = true

		backgroundColor = Constants.Appearance.backgroundColor
		tintColor = Constants.Appearance.tintColor
		setImage(Constants.Appearance.image, for: .normal)
		tintColor = R.color.tableViewColor()
	}
	
}
