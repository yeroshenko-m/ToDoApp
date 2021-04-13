//
//  NSObject+protocol.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 06.02.2021.
//

import Foundation

extension NSObject {

    class var nameOfClass: String {
		String(describing: self)
    }

}
