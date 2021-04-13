//
//  SpeechRecognizerButton.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 02.04.2021.
//

import UIKit

private enum Constants {
	static let pulseKey = "pulse"
	static let transformScaleKey = "transform.scale.xy"
	static let opacityKey = "opacity"
	static let opacityValues: [NSNumber] = [0.4, 0.8, 0]
	static let animationKeyTimes: [NSNumber] = [0, 0.2, 1]
	static let scaleAnimationToValue = 1
	static let sizeMultiplier: CGFloat = 2
	static let color = R.color.iconsTintColor()
}

final class Pulsing: CALayer {

	// MARK: - Properties

	private var animationGroup = CAAnimationGroup()

	private let initialPulseScale: Float = 0
	private let nextPulseAfter: TimeInterval = 0
	private let animationDuration: TimeInterval = 1.5
	private var radius = CGFloat.zero
	private var numberOfPulses: Float = Float.infinity

	// MARK: - Init

	override init(layer: Any) {
		super.init(layer: layer)
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}

	init (numberOfPulses: Float = .infinity,
		  radius: CGFloat,
		  position: CGPoint) {
		super.init()

		self.backgroundColor = Constants.color?.cgColor
		self.contentsScale = UIScreen.main.scale
		self.opacity = .zero
		self.radius = radius
		self.numberOfPulses = numberOfPulses
		self.position = position

		self.bounds = CGRect(x: .zero,
							 y: .zero,
							 width: radius * Constants.sizeMultiplier,
							 height: radius * Constants.sizeMultiplier)

		self.cornerRadius = radius

		DispatchQueue.global(qos: .default).async {
			self.setupAnimationGroup()

			DispatchQueue.main.async {
				self.add(self.animationGroup, forKey: Constants.pulseKey)
			}
		}

	}

	// MARK: - Config

	private func createScaleAnimation () -> CABasicAnimation {
		let scaleAnimation = CABasicAnimation(keyPath: Constants.transformScaleKey)
		scaleAnimation.fromValue = NSNumber(value: initialPulseScale)
		scaleAnimation.toValue = NSNumber(value: Constants.scaleAnimationToValue)
		scaleAnimation.duration = animationDuration

		return scaleAnimation
	}

	private func createOpacityAnimation() -> CAKeyframeAnimation {

		let opacityAnimation = CAKeyframeAnimation(keyPath: Constants.opacityKey)
		opacityAnimation.duration = animationDuration
		opacityAnimation.values = Constants.opacityValues
		opacityAnimation.keyTimes = Constants.animationKeyTimes

		return opacityAnimation
	}

	private func setupAnimationGroup() {
		self.animationGroup = CAAnimationGroup()
		self.animationGroup.duration = animationDuration + nextPulseAfter
		self.animationGroup.repeatCount = numberOfPulses

		let defaultCurve = CAMediaTimingFunction(name: .default)
		self.animationGroup.timingFunction = defaultCurve

		self.animationGroup.animations = [createScaleAnimation(), createOpacityAnimation()]

	}

}
