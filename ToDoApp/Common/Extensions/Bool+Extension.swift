//
//  Bool+Extension.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 12.02.2021.
//

import Foundation

extension Bool {
    
    static func < (lhs: Self, rhs: Self) -> Self {
        return lhs == false && rhs == true
    }
    
    static func > (lhs: Self, rhs: Self) -> Self {
        return lhs == true && rhs == false
    }
    
}
