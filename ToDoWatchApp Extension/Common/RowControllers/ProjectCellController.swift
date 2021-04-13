//
//  ProjectCellController.swift
//  ToDoWatchApp Extension
//
//  Created by Mykhailo Yeroshenko on 08.04.2021.
//

import WatchKit

final class ProjectCellController: NSObject {

	private var project: Project?

	@IBOutlet private weak var titleImage: WKInterfaceImage!
	@IBOutlet private weak var titleLabel: WKInterfaceLabel!
	@IBOutlet private weak var favoriteView: WKInterfaceImage!

	func configureWith(project: Project) {
		self.project = project
		let image = project.name == "Inbox" ?
			UIImage(systemName: "rectangle.stack.fill") :
			UIImage(systemName: "square.stack.3d.up.fill")
		titleImage.setImage(image)
		titleImage.setTintColor(TodoistColor.getColorBy(id: project.color))
		titleLabel.setText(project.name)
		let color: UIColor = project.favorite ? .orange : .clear
		favoriteView.setTintColor(color)
	}

}
