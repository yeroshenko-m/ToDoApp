//
//  RowTypeConvertible.swift
//  ToDoWatchApp Extension
//
//  Created by Mykhailo Yeroshenko on 08.04.2021.
//

import Foundation

protocol RowTypeConvertible {
	var rowType: String { get }
}

extension RowTypeConvertible {
	var rowType: String {
		String(describing: Self.self)
	}
}
