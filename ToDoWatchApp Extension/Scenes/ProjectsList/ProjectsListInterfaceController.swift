//
//  ProjectsListInterfaceController.swift
//  ToDoWatchApp Extension
//
//  Created by Mykhailo Yeroshenko on 08.04.2021.
//

import WatchKit

final class ProjectsListInterfaceController: BaseInterfaceController {

	// MARK: - IBOutlets

	@IBOutlet weak var emptyViewTitleLabel: WKInterfaceLabel!
	@IBOutlet private weak var table: WKInterfaceTable!

	// MARK: - Properties

	private var projects = [Project]() {
		didSet {
			screenState = projects.isEmpty ? .empty : .full
		}
	}
	private let storage = WatchStorageManager.shared

	// MARK: - Lifecycle

	override func willActivate() {
		super.willActivate()
		fetchProjects()
	}

	override func didDeactivate() {
		clearProjectsList()
		clearTable()
	}

	// MARK: - Private funcs

	private func fetchProjects() {
		guard let cachedProjects = storage.fetchCachedProjects()
		else {
			clearTable()
			clearProjectsList()
			return
		}
		projects = cachedProjects
	}

	private func displayProjects() {
		for (index, project) in projects.enumerated() {
			table.insertRows(at: .init(integer: index), ofType: .projectCell)
			if let row = table.rowController(at: index) as? ProjectCellController {
				row.configureWith(project: project)
			}
		}
	}

	private func clearProjectsList() {
		projects.removeAll()
	}

	private func clearTable() {
		table.removeRows(at: .init(0..<table.numberOfRows))
	}

	// MARK: - Override methods

	override func table(_ table: WKInterfaceTable,
						didSelectRowAt rowIndex: Int) {
		pushController(.projectDetails, context: projects[rowIndex])
	}

	override func refreshScreenState() {
		clearTable()
		switch screenState {
		case .empty:
			table.setHidden(true)
			emptyViewTitleLabel.setText("Projects list is unavailable")
			emptyViewTitleLabel.setHidden(false)
		case .full:
			table.setHidden(false)
			emptyViewTitleLabel.setHidden(true)
			displayProjects()
		}
	}

	override func storageChangesHandler() {
		fetchProjects()
	}

}
