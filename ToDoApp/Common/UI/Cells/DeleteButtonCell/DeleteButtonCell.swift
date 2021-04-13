//
//  DeleteMenuButtonTableViewCell.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 05.02.2021.
//

import UIKit

protocol DeleteButtonCellDelegate: class {

    func didPressDeleteButton(_ sender: UITableViewCell)

}

final class DeleteButtonCell: UITableViewCell {

	// MARK: - Properties

	weak var delegate: DeleteButtonCellDelegate?

	// MARK: - IBOutlets

	@IBOutlet weak var deleteButton: UIButton!
    
	// MARK: - IBActions

    @IBAction private func deleteButtonDidPress(_ sender: UIButton) {
        delegate?.didPressDeleteButton(self)
    }

	// MARK: - Cell lifecycle

	override func layoutSubviews() {
		super.layoutSubviews()
		backgroundColor = R.color.cellsColor()
	}

	// MARK: - Config
	
	private func configureDeleteButtonAppearance() {
		deleteButton.tintColor = R.color.iconsTintColor()
	}
    
}
