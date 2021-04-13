//
//  Storyboards.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 06.02.2021.
//

import UIKit

enum Storyboards: String {
    
    case auth
    case projectDetails
    case projectsList
    case settings
    case taskslist
	case splitmenu
    
    var storyboard: UIStoryboard {
        UIStoryboard(name: self.rawValue.capitalized,
                     bundle: .main)
    }
    
}
