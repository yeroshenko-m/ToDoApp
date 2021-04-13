//
//  CellViewModel.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 28.01.2021.
//

import UIKit

struct ColorCellDisplayObject {
	
    let color: UIColor
	
}

extension ColorCellDisplayObject: CellViewModel {
	
    func setup(cell: ColorCVCell) {
        cell.colorView.backgroundColor = color
    }

}
