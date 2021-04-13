//
//  AddButton.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 22.01.2021.
//

import UIKit

private enum Constants {

	enum Shadow {
		static let offset = CGSize(width: 1.5, height: 1.5)
		static let radius: CGFloat = 2.5
		static let opacity: Float = 0.5
	}

	enum Appearance {
		static let tintColor = R.color.cellsColor()
		static let backgroundColor = R.color.iconsTintColor()
		static let image = R.image.add()?.withRenderingMode(.alwaysTemplate)
		static let cornerMultiplier: CGFloat = 2.0
	}

	enum Frame {
		static let width: CGFloat = 50.0
		static var height: CGFloat { width }
		static let heightPadding: CGFloat = -6
		static let widthPadding: CGFloat = -9.6
	}

}

final class AddButton: UIButton {

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
	}

	func pinTo(_ superview: UIView) {
		superview.addSubview(self)
		translatesAutoresizingMaskIntoConstraints = false
		let heightPadding = UIScreen.main.bounds.height / Constants.Frame.heightPadding
		let widthPadding = UIScreen.main.bounds.width / Constants.Frame.widthPadding
		NSLayoutConstraint.activate([
			trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: widthPadding),
			bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: heightPadding),
			heightAnchor.constraint(equalToConstant: Constants.Frame.width),
			widthAnchor.constraint(equalToConstant: Constants.Frame.height)
		])
	}

}
