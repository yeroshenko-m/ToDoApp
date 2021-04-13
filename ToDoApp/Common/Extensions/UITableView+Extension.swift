//
//  Extension for UITableView.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 25.01.2021.
//

import UIKit

private enum Constants {

	static let emptyViewTileLabelNumberOfLines = 1
	static let emptyViewMessageLabelNumberOfLines = 0
	static let emptyViewTitleLabelFont = UIFont(name: "HelveticaNeue-Bold",
												size: 18)
	static let emptyViewMessageLabelFont = UIFont(name: "HelveticaNeue-Regular",
												  size: 17)
	static let emptyViewTitleLabelCenterYConstraintConstant: CGFloat = -50
	static let emptyViewMessageLabelTopAnchorConstraintConstant: CGFloat = 20
	static let emptyViewMessageLabelLeftAnchorConstraintConstant = emptyViewMessageLabelTopAnchorConstraintConstant
	static let emptyViewMessageLabelRightAnchorConstraintConstant = -emptyViewMessageLabelTopAnchorConstraintConstant

}

extension UITableView {
    
    func register(_ cellTypes: [UITableViewCell.Type]) {
        cellTypes.forEach {
            self.register($0.nib(),
						  forCellReuseIdentifier: $0.reuseIdentifier)
        }
    }
    
    func dequeueReusableCell(withModel model: CellViewAnyModel,
							 for indexPath: IndexPath) -> UITableViewCell {
        let identifier = type(of: model).cellAnyType.reuseIdentifier
        let cell = self.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
        model.setupAny(cell: cell)
        return cell
    }
    
    func register(nibModels: [CellViewAnyModel.Type]) {
        for model in nibModels {
            self.register(model.cellAnyType.nib(),
                          forCellReuseIdentifier: model.cellAnyType.reuseIdentifier)
        }
    }

    func setEmptyView(title: String,
                      message: String) {
        let emptyView = UIView(frame: CGRect(x: self.center.x,
                                             y: self.center.y,
                                             width: self.bounds.size.width,
                                             height: self.bounds.size.height))
        
        let titleLabel = UILabel()
        titleLabel.text = title
		titleLabel.numberOfLines = Constants.emptyViewTileLabelNumberOfLines
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .label
		titleLabel.font = Constants.emptyViewTitleLabelFont
        
        let messageLabel = UILabel()
        messageLabel.text = message
		messageLabel.numberOfLines = Constants.emptyViewMessageLabelNumberOfLines
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.textColor = .secondaryLabel
        messageLabel.font = Constants.emptyViewMessageLabelFont
        
        [titleLabel, messageLabel].forEach { emptyView.addSubview($0) }

		titleLabel.centerXAnchor.constraint(equalTo: emptyView.centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: emptyView.centerYAnchor,
											constant: Constants.emptyViewTitleLabelCenterYConstraintConstant).isActive = true
        messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor,
										  constant: Constants.emptyViewMessageLabelTopAnchorConstraintConstant).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: emptyView.leftAnchor,
										   constant: Constants.emptyViewMessageLabelLeftAnchorConstraintConstant).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: emptyView.rightAnchor,
											constant: Constants.emptyViewMessageLabelRightAnchorConstraintConstant).isActive = true
        messageLabel.textAlignment = .center
        
        self.backgroundView = emptyView
        self.separatorStyle = .none
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }

}
