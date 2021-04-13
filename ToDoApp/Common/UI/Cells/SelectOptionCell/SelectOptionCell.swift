//
//  DisclosureItemTableViewCell.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 26.01.2021.
//

import UIKit

final class SelectOptionCell: UITableViewCell {

	// MARK: - IBOutlets

	@IBOutlet weak var menuItemNameLabel: UILabel! {
        didSet {
			configureMenuItemNameLabelAppearance()
        }
    }
    @IBOutlet weak var detailImageView: UIImageView! {
        didSet {
			configureImageAppearance()
        }
    }

	// MARK: - Cell lifecycle

	override func layoutSubviews() {
		super.layoutSubviews()
		backgroundColor = R.color.cellsColor()
		tintColor = R.color.iconsTintColor()
	}

	// MARK: - Config

	private func configureMenuItemNameLabelAppearance() {
		menuItemNameLabel.numberOfLines = 1
	}

	private func configureImageAppearance() {
		detailImageView.tintColor = R.color.iconsTintColor()
	}

}
