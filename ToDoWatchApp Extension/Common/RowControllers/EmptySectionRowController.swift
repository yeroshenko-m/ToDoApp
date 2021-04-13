//
//  EmptySectionRowController.swift
//  ToDoWatchApp Extension
//
//  Created by Mykhailo Yeroshenko on 11.04.2021.
//

import WatchKit

final class EmptySectionRowController: NSObject {

	@IBOutlet private weak var titleLabel: WKInterfaceLabel!

	func configure(withTitle text: String?) {
		titleLabel.setText(text)
	}
	
}
