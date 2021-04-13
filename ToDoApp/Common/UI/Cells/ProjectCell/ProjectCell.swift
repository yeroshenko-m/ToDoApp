//
//  ProjectTableViewCell.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 24.01.2021.
//

import UIKit

final class ProjectCell: UITableViewCell {
	
	// MARK: - IBOutlets

	@IBOutlet weak var projectIcon: UIImageView!
	@IBOutlet weak var projectNameLabel: UILabel!
	@IBOutlet weak var favoriteImageView: UIImageView! {
		didSet {
			configureFavoriteImageViewAppearance()
		}
	}

	// MARK: - Cell lifecycle

	override func layoutSubviews() {
		super.layoutSubviews()
		backgroundColor = R.color.cellsColor()
		tintColor = R.color.iconsTintColor()
	}
	
	// MARK: - Config
	
	private func configureFavoriteImageViewAppearance() {
		favoriteImageView.tintColor = .systemOrange
	}
	
}
