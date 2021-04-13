//
//  ProjectCellViewModel.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 04.02.2021.
//

import Foundation
import UIKit

struct ProjectCellDisplayObject {

    let project: Project
    
    var name: String {
		project.name
	}

    var isFavorite: Bool {
		project.favorite
	}

    var color: UIColor {
		TodoistColor.getColorBy(id: project.color)
	}

}

extension ProjectCellDisplayObject: CellViewModel {

    func setup(cell: ProjectCell) {
        let inboxImage = R.image.folderSingleFill()?.withRenderingMode(.alwaysTemplate)
        let projectImage = R.image.listFill()?.withRenderingMode(.alwaysTemplate)
        cell.projectNameLabel.text = name
        cell.favoriteImageView.isHidden = !isFavorite
        cell.projectIcon?.image = project.name == "Inbox" ? inboxImage : projectImage
        cell.projectIcon?.tintColor = color
    }

}
