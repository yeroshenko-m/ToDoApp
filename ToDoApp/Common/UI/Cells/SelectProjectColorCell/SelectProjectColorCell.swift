//
//  DetailColorListTableViewCell.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 28.01.2021.
//

import UIKit

class SelectProjectColorCell: UITableViewCell {

	// MARK: - IBOutlets

    @IBOutlet weak var menuItemNameLabel: UILabel!
    @IBOutlet weak var colorPreviewView: UIView!

	// MARK: - Cell lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()
        colorPreviewView.layer.cornerRadius = colorPreviewView.frame.height / 2
    }

}
