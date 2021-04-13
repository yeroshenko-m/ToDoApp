//
//  NoNetworkView.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 24.03.2021.
//

import UIKit

// MARK: - Consts

private enum Constants {

	static let animationSpringDamping: CGFloat = 0.4
	static let animationStartVelocity: CGFloat = .zero
	static let animationDuration: TimeInterval = 0.6
	static let animationDelay: TimeInterval = 0.0
	static let bannerHeight: CGFloat = 25.0
	static let bannerHeightMultiplier: CGFloat = 2.0
	static let fontSize: CGFloat = 12.0
	static let topPadding: CGFloat = 30.0

}

final class NoNetworkView: UIView {

	// MARK: - Static properties

	static let frame = CGRect.zero

	// MARK: - Properties

	private let titleLabel: UILabel

	// MARK: - Init

	override init(frame: CGRect) {
		titleLabel = UILabel()
		super.init(frame: frame)
		configureLabel()
		configureAppearance()
	}

	required init?(coder: NSCoder) {
		titleLabel = UILabel()
		super.init(coder: coder)
		configureLabel()
		configureAppearance()
	}

	// MARK: - Config

	private func configureLabel() {
		addSubview(titleLabel)
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		NSLayoutConstraint.activate([
			titleLabel.topAnchor.constraint(equalTo: topAnchor),
			titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
			titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
			titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
		])
		titleLabel.textAlignment = .center
		titleLabel.text = R.string.localizable.noNetworkView_title()
		titleLabel.font = .systemFont(ofSize: Constants.fontSize, weight: .semibold)
		titleLabel.textColor = .white
		titleLabel.textAlignment = .center
	}

	private func configureAppearance() {
		backgroundColor = .systemBlue
		isOpaque = false
	}

	// MARK: - API

	func show(on view: UIView, animated: Bool) {
		view.addSubview(self)
		view.bringSubviewToFront(self)
		translatesAutoresizingMaskIntoConstraints = false

		NSLayoutConstraint.activate([
			trailingAnchor.constraint(equalTo: view.trailingAnchor),
			leadingAnchor.constraint(equalTo: view.leadingAnchor),
			heightAnchor.constraint(equalToConstant: Constants.bannerHeight)
		])

		center.y = view.frame.minY - Constants.bannerHeight / Constants.bannerHeightMultiplier

		if animated {
			UIView.animate(withDuration: Constants.animationDuration,
						   delay: Constants.animationDelay,
						   usingSpringWithDamping: Constants.animationSpringDamping,
						   initialSpringVelocity: Constants.animationStartVelocity,
						   options: .curveLinear,
						   animations: {
							self.center.y += Constants.bannerHeight
						   },
						   completion: nil)
		} else {
			self.center.y += Constants.bannerHeight
		}
	}

	func hide(completion: @escaping () -> Void) {
		UIView.animate(withDuration: Constants.animationDuration,
					   delay: Constants.animationDelay,
					   usingSpringWithDamping: Constants.animationSpringDamping,
					   initialSpringVelocity: Constants.animationStartVelocity,
					   options: .curveLinear,
					   animations: {
						self.center.y -= Constants.bannerHeight * Constants.bannerHeightMultiplier
					   },
					   completion: nil)

		UIView.animate(withDuration: Constants.animationDuration) {
			self.center.y -= Constants.bannerHeight * Constants.bannerHeightMultiplier
			completion()
		} completion: { _ in
			self.removeFromSuperview()
		}
	}

}
