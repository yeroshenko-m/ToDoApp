//
//  SelectProjectColorPresenterImpl.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 07.03.2021.
//

import Foundation

// MARK: - Protocol

protocol SelectProjectColorPresenter {
	func present(colors: [TodoistColor.Color])
}

// MARK: - Presenter

final class SelectProjectColorPresenterImpl {

	// MARK: - Properties

	private weak var view: SelectProjectColorView?

	// MARK: - Init

	init(view: SelectProjectColorView) {
		self.view = view
	}

}

// MARK: - Presentation logic

extension SelectProjectColorPresenterImpl: SelectProjectColorPresenter {

	func present(colors: [TodoistColor.Color]) {
		view?.display(colors: colors)
	}
	
}
