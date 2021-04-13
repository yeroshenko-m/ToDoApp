//
//  ToggleButtonCellDisplayObject.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 02.02.2021.
//

import Foundation
import UIKit

struct ToggleButtonCellDisplayObject {
	
    let detailImage: UIImage
    let menuItemName: String
    let boolValue: Bool
	
}

extension ToggleButtonCellDisplayObject: CellViewModel {
	
    func setup(cell: ToggleButtonCell) {
        cell.detailImageView.image = detailImage
        cell.menuItemNameLabel?.text = menuItemName
        cell.toggleButton.setOn(boolValue, animated: false)
        cell.setDetailImageFilled(boolValue)
    }
	
}
