//
//  SplitMenuPresenterImpl.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 06.04.2021.
//

import Foundation

// MARK: - Protocol

protocol SplitMenuPresenter {
	func present(sections: [SplitMenuScreenSections])
}

// MARK: - Presenter

final class SplitMenuPresenterImpl {

	// MARK: - Properties

	weak var view: SplitMenuView?

	// MARK: - Init

	init(view: SplitMenuView) {
		self.view = view
	}

}

// MARK: - Presentation logic

extension SplitMenuPresenterImpl: SplitMenuPresenter {

	func present(sections: [SplitMenuScreenSections]) {
		view?.display(menuSections: sections)
	}

}
