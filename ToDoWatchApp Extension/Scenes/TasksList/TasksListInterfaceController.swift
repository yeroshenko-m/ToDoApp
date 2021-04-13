//
//  TasksListInterfaceController.swift
//  ToDoWatchApp Extension
//
//  Created by Mykhailo Yeroshenko on 08.04.2021.
//

import WatchKit

final class TasksListInterfaceController: BaseInterfaceController {

	// MARK: - IBOutlets

	@IBOutlet weak var emptyViewTitleLabel: WKInterfaceLabel!
	@IBOutlet private weak var table: WKInterfaceTable!

	// MARK: - Properties

	private var sections = [TasksListSection]() {
		didSet {
			screenState = sections.isEmpty ? .empty : .full
		}
	}
	private let storage = WatchStorageManager.shared

	// MARK: - Lifecycle

	override func awake(withContext context: Any?) {
		super.awake(withContext: context)
		clearTable()
		clearTasksList()
	}

	override func willActivate() {
		super.willActivate()
		fetchSections()
	}

	// MARK: - Config

	private func fetchSections() {
		guard let cachedSections = storage.fetchCachedTasksProjectSections()
		else {
			clearTable()
			clearTasksList()
			return
		}
		sections = cachedSections
	}

	private func displaySections() {
		sections.forEach {
			displaySection($0)
		}
	}

	private func displaySection(_ section: TasksListSection) {
		let rows = table.numberOfRows
		table.insertRows(at: NSIndexSet(index: rows) as IndexSet,
						 ofType: .tableSectionCell)

		let itemRows = NSIndexSet(indexesIn: NSRange(location: rows + 1,
													 length: section.tasks.count))
		table.insertRows(at: itemRows as IndexSet,
						 ofType: .taskCell)

		for index in rows..<table.numberOfRows {
			let controller = table.rowController(at: index)

			if let controller = controller as? TableSectionCellController {
				controller.configure(asSection: .project,
									 withTitle: section.name,
									 isFirstSection: true)
			} else if let controller = controller as? TaskCellController {
				let task = section.tasks[index - rows - 1]
				controller.configureWith(task: task)
			}
		}

	}

	private func clearTable() {
		table.removeRows(at: .init(0..<table.numberOfRows))
	}

	private func clearTasksList() {
		sections.removeAll()
	}

	// MARK: - Methods

	override func table(_ table: WKInterfaceTable,
						didSelectRowAt rowIndex: Int) {
		var selectedIndex = -1

		for section in sections {
			selectedIndex += 1
			for task in section.tasks {
				selectedIndex += 1
				if rowIndex == selectedIndex {
					pushController(.taskDetails, context: task)
				}
			}
		}
	}

	override func refreshScreenState() {
		clearTable()
		switch screenState {
		case .empty:
			table.setHidden(true)
			emptyViewTitleLabel.setText("Tasks list is unavailable")
			emptyViewTitleLabel.setHidden(false)
		case .full:
			table.setHidden(false)
			emptyViewTitleLabel.setHidden(true)
			displaySections()
		}
	}

	override func storageChangesHandler() {
		fetchSections()
	}

}
