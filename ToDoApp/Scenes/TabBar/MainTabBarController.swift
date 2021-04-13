//
//  MainTabBarController.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 10.02.2021.
//

import UIKit

final class MainTabBarController: UITabBarController {
    
    // MARK: - VC lifecycle
	
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAppearance()
    }
    
    // MARK: - Config

    private func configureAppearance() {
		tabBar.tintColor = R.color.iconsTintColor()
	}

	override func tabBar(_ tabBar: UITabBar,
						 didSelect item: UITabBarItem) {
		if item != tabBar.selectedItem {
			UISelectionFeedbackGenerator().selectionChanged()
		}
	}

}
