//
//  TableView.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 05.03.2021.
//

import UIKit

final class TableView: UITableView {
	
	// MARK: - Consts

	let tableViewTopInset: CGFloat = 15.0
	let tableViewSectionHeight: CGFloat = 25.0
	let tableViewRowHeight: CGFloat = SystemHelper.isRunningOnMacCatalyst ? 65.0 : 55.0
	let tableViewSeparatorInsets = UIEdgeInsets(top: 0,
												left: 25.0,
												bottom: 0,
												right: 25.0)
	
	// MARK: - Init
	
	override init(frame: CGRect,
				  style: UITableView.Style) {
		super.init(frame: frame,
				   style: style)
		configureTableViewAppearance()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		configureTableViewAppearance()
	}

	// MARK: - Config

	func configureTableViewAppearance() {
		separatorInset = tableViewSeparatorInsets
		backgroundColor = R.color.tableViewColor()
		tableFooterView = UIView()
		estimatedRowHeight = tableViewRowHeight
		rowHeight = UITableView.automaticDimension
		keyboardDismissMode = .interactive
	}

	func setMinimalTopInset() {
		contentInset.top = -20.0
	}

	func setNormalTopInset() {
		contentInset.top = tableViewTopInset
	}

	func setAdditionalTopInset() {
		contentInset.top = tableViewTopInset * 2
	}

}
