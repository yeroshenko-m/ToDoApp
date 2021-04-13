//
//  Delete.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 05.02.2021.
//

import Foundation

struct DeleteButtonDisplayObject {

    let buttonTitle: String
	
}

extension DeleteButtonDisplayObject: CellViewModel {

    func setup(cell: DeleteButtonCell) {
        cell.deleteButton.setTitle(buttonTitle, for: .normal)
    }

}
