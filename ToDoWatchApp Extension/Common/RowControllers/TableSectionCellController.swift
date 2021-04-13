//
//  TableSectionCellController.swift
//  ToDoWatchApp Extension
//
//  Created by Mykhailo Yeroshenko on 08.04.2021.
//

import WatchKit

final class TableSectionCellController: NSObject {

	enum SectionType {
		case project, date
	}

	@IBOutlet private weak var titleImage: WKInterfaceImage!
	@IBOutlet private weak var titleLabel: WKInterfaceLabel!
	@IBOutlet weak var topSeparator: WKInterfaceSeparator!

	func configure(asSection type: SectionType,
				   withTitle text: String,
				   isFirstSection: Bool) {
		switch type {
		case .project:
			titleLabel.setText(text)
			titleImage.setImage(UIImage(systemName: "square.stack.3d.up.fill"))
		case .date:
			let dateString = DateFormatter().sectionDateString(from: text)
			titleLabel.setText(dateString)
			titleImage.setImage(UIImage(systemName: "calendar"))
			if isFirstSection {
				titleImage.setTintColor(.yellow)
			}
		}

		topSeparator.setHidden(isFirstSection)
	}

}
