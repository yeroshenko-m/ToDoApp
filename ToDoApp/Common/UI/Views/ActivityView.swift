//
//  ActivityView.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 14.02.2021.
//

import NVActivityIndicatorView

private enum Constants {

	static let width: CGFloat = 100
	static let height = width
	static let halfWidth = width / 2
	static let halfHeight = height / 2
	static let padding: CGFloat = 0

}

final class ActivityView {

	// MARK: - Properties

    private let indicatorView: NVActivityIndicatorView

	// MARK: - Init

	init(view: UIView) {
        indicatorView = NVActivityIndicatorView(frame: .init(x: view.frame.midX - Constants.halfWidth,
                                                             y: view.frame.midY - Constants.halfHeight * 3,
                                                             width: Constants.width,
                                                             height: Constants.height),
												type: .ballClipRotate,
												color: R.color.iconsTintColor(),
												padding: Constants.padding)
		view.addSubview(indicatorView)

	}

	// MARK: - API

    func startAnimating() {
        indicatorView.startAnimating()
    }
    
    func stopAnimating() {
        indicatorView.stopAnimating()
    }
    
}
