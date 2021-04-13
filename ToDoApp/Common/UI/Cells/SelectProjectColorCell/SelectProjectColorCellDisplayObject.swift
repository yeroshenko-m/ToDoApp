//
//  DetailColorListTableViewCellModel.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 02.02.2021.
//

import Foundation

struct SelectProjectColorCellDisplayObject {
	
    let menuItemName: String
    let todoistColorPreviewId: Int
	
}

extension SelectProjectColorCellDisplayObject: CellViewModel {
	
    func setup(cell: SelectProjectColorCell) {
        cell.menuItemNameLabel?.text = menuItemName
        cell.colorPreviewView.backgroundColor = TodoistColor.getColorBy(id: todoistColorPreviewId)
    }
	
}
