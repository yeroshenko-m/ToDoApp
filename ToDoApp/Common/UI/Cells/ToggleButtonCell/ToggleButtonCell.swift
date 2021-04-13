//
//  MenuItemTableViewCell.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 25.01.2021.
//

import UIKit

protocol ToggleButtonCellDelegate: class {
    func switchDidChangeState(to state: Bool)
}

class ToggleButtonCell: UITableViewCell {

	// MARK: - Properties
    
    private let onImage = R.image.bookmark1()?.withRenderingMode(.alwaysTemplate)
    private let offImage = R.image.bookmarkFill1()?.withRenderingMode(.alwaysTemplate)

	weak var delegate: ToggleButtonCellDelegate?

	// MARK: - IBOutlets

    @IBOutlet weak var toggleButton: UISwitch! {
        didSet {
            toggleButton.onTintColor = TodoistColor.orange.value
        }
    }
    
    @IBOutlet weak var detailImageView: UIImageView! {
        didSet {
            detailImageView.tintColor = TodoistColor.orange.value
        }
    }

    @IBOutlet weak var menuItemNameLabel: UILabel! {
        didSet {
            menuItemNameLabel.numberOfLines = 1
        }
    }

	// MARK: - IBActions

    @IBAction func switchDidChangeValue(_ sender: UISwitch) {
        delegate?.switchDidChangeState(to: sender.isOn)
        UIView.transition(with: detailImageView,
                                  duration: 0.5,
                                  options: .transitionCrossDissolve,
                                  animations: {
                                    self.detailImageView.image = self.toggleButton.isOn ? self.onImage : self.offImage
                                  },
                                  completion: nil)
    }

    func setDetailImageFilled(_ bool: Bool) {
        detailImageView.image = self.toggleButton.isOn ? self.onImage : self.offImage
    }

	// MARK: - Cell lifecycle

	override func layoutSubviews() {
		super.layoutSubviews()
		backgroundColor = R.color.cellsColor()
		tintColor = R.color.iconsTintColor()
	}
	
}
