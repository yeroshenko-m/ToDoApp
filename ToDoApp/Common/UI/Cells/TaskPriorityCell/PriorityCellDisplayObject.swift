//
//  PriorityCellViewModel.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 02.02.2021.
//

import UIKit

struct PriorityCellDisplayObject {

    let priority: Priority
    
    var name: String {
		priority.description
	}
    var color: UIColor {
		priority.color
	}

}

extension PriorityCellDisplayObject: CellViewModel {

    func setup(cell: TaskPriorityCell) {
        cell.priorityIconImageView.tintColor = color
        cell.priorityNameLabel.text = name
    }
	
}
