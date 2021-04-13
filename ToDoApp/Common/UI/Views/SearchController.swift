//
//  SearchController.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 14.03.2021.
//

import UIKit

class SearchController: UISearchController {

	func configure(placeholder: String) {
		obscuresBackgroundDuringPresentation = false
		hidesNavigationBarDuringPresentation = true
		definesPresentationContext = true

		searchBar.placeholder = placeholder
		searchBar.isTranslucent = true
		searchBar.searchTextField.tintColor = R.color.searchBarColor()
		searchBar.searchTextField.backgroundColor = R.color.searchBarColor()
		searchBar.returnKeyType = .done
	}

}
