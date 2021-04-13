//
//  MainMenuCellController.swift
//  ToDoWatchApp Extension
//
//  Created by Mykhailo Yeroshenko on 08.04.2021.
//

import WatchKit

final class MainMenuCellController: NSObject {

	@IBOutlet private weak var titleImage: WKInterfaceImage!
	@IBOutlet private weak var titleLabel: WKInterfaceLabel!

	func configureWith(image: UIImage?, text: String) {
		titleImage.setImage(image)
		titleLabel.setText(text)
	}

}
