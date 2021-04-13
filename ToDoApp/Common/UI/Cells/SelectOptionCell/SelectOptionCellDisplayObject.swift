//
//  SelectOptionCellDisplayObject.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 02.02.2021.
//

import UIKit

struct SelectOptionCellDisplayObject {

    let menuItemName: String
    let detailImage: UIImage

}

extension SelectOptionCellDisplayObject: CellViewModel {

    func setup(cell: SelectOptionCell) {
        cell.menuItemNameLabel?.text = menuItemName
        cell.detailImageView.image = detailImage
    }
}
