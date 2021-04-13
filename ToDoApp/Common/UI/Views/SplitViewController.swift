//
//  SplitViewController.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 07.04.2021.
//

import UIKit

private enum Constants {
	static let minimumPrimaryColumnWidthMultiplier: CGFloat = 4.0
	static let maximumPrimaryColumnWidthMultiplier: CGFloat = 3.0
	static let preferredPrimaryColumnWidthMultiplier: CGFloat = 3.5
}

final class SplitViewController: UISplitViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		configureAppearance()
	}

	// MARK: - Config

	private func configureAppearance() {
		view.tintColor = R.color.navigationBarTextColor()
		preferredDisplayMode = .automatic
		minimumPrimaryColumnWidth = view.bounds.width / Constants.minimumPrimaryColumnWidthMultiplier
		maximumPrimaryColumnWidth = view.bounds.width / Constants.maximumPrimaryColumnWidthMultiplier
		preferredPrimaryColumnWidth = view.bounds.width / Constants.preferredPrimaryColumnWidthMultiplier
	}

}
