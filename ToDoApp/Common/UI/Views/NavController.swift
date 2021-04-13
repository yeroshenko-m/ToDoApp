//
//  NavController.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 11.03.2021.
//

import UIKit

final class NavController: UINavigationController {
	
	// MARK: - VC Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
		configureAppearance()
		if SystemHelper.isRunningOnMacCatalyst {
			modalPresentationStyle = .fullScreen
		}
	}

	// MARK: - Config

	private func configureAppearance() {
		let appearance = UINavigationBarAppearance()
		appearance.backgroundColor = R.color.navigationBarColor()
		appearance.titleTextAttributes = [.foregroundColor: R.color.navigationBarTextColor() ?? .white]
		appearance.largeTitleTextAttributes = [.foregroundColor: R.color.navigationBarTextColor() ?? .white]
		navigationBar.tintColor = R.color.navigationBarTextColor()
		navigationBar.standardAppearance = appearance
		navigationBar.compactAppearance = appearance
		navigationBar.scrollEdgeAppearance = appearance
		navigationBar.isTranslucent = false
	}

}
