//
//  ScheduleInterfaceController.swift
//  ToDoWatchApp Extension
//
//  Created by Mykhailo Yeroshenko on 08.04.2021.
//

import WatchKit

final class ScheduleInterfaceController: BaseInterfaceController {

	// MARK: - IBOutlets

	@IBOutlet private weak var table: WKInterfaceTable!
	@IBOutlet weak var emptyViewLabel: WKInterfaceLabel!

	// MARK: - Properties

	private var sections = [TasksListSection]() {
		didSet {
			screenState = sections.allSectionsAreEmpty ? .empty : .full
		}
	}
	private let storage = WatchStorageManager.shared

	// MARK: - Lifecycle

	override func awake(withContext context: Any?) {
		super.awake(withContext: context)
		clearTasksList()
		clearTable()
	}

	override func willActivate() {
		super.willActivate()
		fetchSections()
	}

	// MARK: - Config

	private func fetchSections() {
		guard let cachedSections = storage.fetchCachedTasksDateSections()
		else {
			clearTasksList()
			clearTable()
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

		let isEmptySection = section.tasks.isEmpty
		let itemRows = NSIndexSet(indexesIn: NSRange(location: rows + 1,
													 length: isEmptySection ? 1 : section.tasks.count))
		table.insertRows(at: itemRows as IndexSet,
						 ofType: isEmptySection ? .emptySectionCell : .taskCell)
		 
		for index in rows..<table.numberOfRows {
			let controller = table.rowController(at: index)
			let isFirstSection = index == 0

			switch controller {
			case let controller as TableSectionCellController:
				controller.configure(asSection: .date,
									 withTitle: section.name,
									 isFirstSection: isFirstSection)
			case let controller as TaskCellController:
				let task = section.tasks[index - rows - 1]
				controller.configureWith(task: task)
			case let controller as EmptySectionRowController:
				controller.configure(withTitle: "No tasks for this day")
			default:
				return
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
			emptyViewLabel.setText("You don't have planned tasks for nearest 7 days")
			emptyViewLabel.setHidden(false)
		case .full:
			table.setHidden(false)
			emptyViewLabel.setHidden(true)
			displaySections()
		}
	}

	override func storageChangesHandler() {
		clearTable()
		clearTasksList()
		Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
			self.fetchSections()
		}
	}

}
