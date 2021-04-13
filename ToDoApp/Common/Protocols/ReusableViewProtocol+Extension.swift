//
//  UICollectionViewCell extension.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 22.01.2021.
//

import UIKit

protocol ReusableView: class {

    static var reuseIdentifier: String { get }

}

extension ReusableView where Self: UIView {

    static var reuseIdentifier: String {
		String(describing: self)
	}

}
