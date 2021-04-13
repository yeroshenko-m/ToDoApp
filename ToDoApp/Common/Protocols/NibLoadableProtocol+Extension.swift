//
//  NibLoadable protocol.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 24.01.2021.
//

import UIKit

protocol NibLoadable: class {

	static var nibName: String { get }
	static func nib() -> UINib

}

extension NibLoadable where Self: UIView {

	static var nibName: String {
		String(describing: self)
	}

	static func nib() -> UINib {
		UINib(nibName: nibName,
			  bundle: .main)
	}

}
