//
//  UIViewController extension.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 05.02.2021.
//

import UIKit

extension UIViewController {

    class func controller(in storyboards: Storyboards) -> Self {
        return instantiateController(in: storyboards.storyboard,
                                     with: nameOfClass)
    }

    private class func instantiateController<T: UIViewController>(in storyboard: UIStoryboard,
                                                                  with identifier: String) -> T {
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }
	
}
