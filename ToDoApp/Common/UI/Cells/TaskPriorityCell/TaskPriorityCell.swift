//
//  TaskPriorityTableViewCell.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 02.02.2021.
//

import UIKit

final class TaskPriorityCell: UITableViewCell {

	// MARK: - IBOutlets

    @IBOutlet weak var priorityIconImageView: UIImageView! {
        didSet {
			configurePriorityIconImageViewAppearance()
        }
    }
    @IBOutlet weak var priorityNameLabel: UILabel!

	// MARK: - Cell lifecycle

	override func layoutSubviews() {
		super.layoutSubviews()
		backgroundColor = R.color.cellsColor()
		tintColor = R.color.iconsTintColor()
	}

	// MARK: - Config

	private func configurePriorityIconImageViewAppearance() {
		priorityIconImageView.image = R.image.flag()?.withRenderingMode(.alwaysTemplate)
	}
        
}
