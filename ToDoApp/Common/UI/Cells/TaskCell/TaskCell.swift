//
//  TaskTableViewCell.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 25.01.2021.
//

import UIKit

protocol TaskCellDelegate: class {

	func closeTaskButtonPressed(_ sender: UITableViewCell)

}

final class TaskCell: UITableViewCell {
	
	// MARK: - Properties

	weak var delegate: TaskCellDelegate?
	var isCloseButtonSelected: Bool { closeTaskButton.isSelected }
	var isOutdated = false {
		didSet {
			configureDueStackAppearance()
		}
	}

	// MARK: - IBOutlets

	@IBOutlet weak var dueStack: UIStackView!
	@IBOutlet weak var closeTaskButton: UIButton! {
		didSet {
			configureCloseTaskButtonAppearance()
		}
	}
	@IBOutlet weak var taskNameLabel: UILabel!
	@IBOutlet weak var taskPriorityImage: UIImageView!
	@IBOutlet weak var taskPriorityLabel: UILabel!
	@IBOutlet weak var dateImage: UIImageView!
	@IBOutlet weak var dateLabel: UILabel!
	
	// MARK: - IBActions

	@IBAction func closeTaskButtonDidTapped(_ sender: UIButton) {
		UISelectionFeedbackGenerator().selectionChanged()
		UIView.animate(withDuration: 0.4) {
			self.closeTaskButton.isSelected = !self.closeTaskButton.isSelected
			self.backgroundColor = self.closeTaskButton.isSelected ? R.color.selectedCellColor() : R.color.cellsColor()
		}
		delegate?.closeTaskButtonPressed(self)
	}
	
	// MARK: - Cell lifecycle

	override func prepareForReuse() {
		super.prepareForReuse()
		closeTaskButton.isSelected = false
		dueStack.isHidden = true
		isOutdated = false
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		backgroundColor = R.color.cellsColor()
		if SystemHelper.isRunningOnMacCatalyst {
			configureFonts()
		}
	}
	
	// MARK: - Config
	
	private func configureDueStackAppearance() {
		dueStack.layer.cornerRadius = 4.0
		dueStack.layer.masksToBounds = true
		dueStack.backgroundColor = isOutdated ? .systemRed : .clear
		dateLabel.textColor = isOutdated ? .systemBackground: .systemRed
		dateImage.tintColor = isOutdated ? .systemBackground: .systemRed
	}
	
	private func configureCloseTaskButtonAppearance() {
		closeTaskButton.isSelected = false
		closeTaskButton.setImage(R.image.button()?.withRenderingMode(.alwaysTemplate), for: .normal)
		closeTaskButton.setImage(R.image.buttonChecked()?.withRenderingMode(.alwaysTemplate), for: .selected)
		closeTaskButton.tintColor = R.color.iconsTintColor()
	}

	private func configureFonts() {
		dateLabel.font = dateLabel.font.withSize(14.0)
		taskPriorityLabel.font = taskPriorityLabel.font.withSize(14.0)
	}
	
}
