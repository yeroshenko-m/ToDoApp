//
//  TextFieldItemTableViewCellModel.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 02.02.2021.
//

import Foundation

struct TextFieldCellDisplayObject {

    let placeholder: String
    let text: String

}

extension TextFieldCellDisplayObject: CellViewModel {

    func setup(cell: TextFieldCell) {
        cell.textField.placeholder = placeholder
        cell.textField.text = text
		
    }
}
