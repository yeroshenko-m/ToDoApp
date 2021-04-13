//
//  ColorCollectionViewCell.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 28.01.2021.
//

import UIKit

final class ColorCVCell: UICollectionViewCell {

	// MARK: - IBOutlets
	
    @IBOutlet weak var colorView: UIView!
    @IBOutlet weak var checkmarkImageView: UIImageView!

	// MARK: - Config

    override func layoutSubviews() {
        super.layoutSubviews()
        clipsToBounds = true
        layer.cornerRadius = frame.height / 2
    }

}
