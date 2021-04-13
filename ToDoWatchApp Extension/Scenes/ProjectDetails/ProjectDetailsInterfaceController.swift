//
//  ProjectDetailsInterfaceController.swift
//  ToDoWatchApp Extension
//
//  Created by Mykhailo Yeroshenko on 08.04.2021.
//

import WatchKit

final class ProjectDetailsInterfaceController: BaseInterfaceController {

	// MARK: - IBOutlets

	@IBOutlet private weak var projectNameLabel: WKInterfaceLabel!
	@IBOutlet private weak var table: WKInterfaceTable!
	@IBOutlet weak var favoriteView: WKInterfaceImage!

	// MARK: - Properties

	private var project: Project? {
		didSet {
			screenState = project == nil ? .empty : .full
		}
	}
	private var tasks = [Task]() {
		didSet {
			screenState = tasks.isEmpty ? .empty : .full
		}
	}
	private let storage = WatchStorageManager.shared

	// MARK: - Lifecycle

	override func awake(withContext context: Any?) {
		super.awake(withContext: context)
		if let selectedProject = context as? Project {
			configureFavoriteView(for: selectedProject)
			project = selectedProject
		}
	}

	override func willActivate() {
		super.willActivate()
		fetchTasks()
	}

	override func didDeactivate() {
		super.didDeactivate()
		clearTasksList()
		clearTable()
	}

	// MARK: - Config

	private func fetchTasks() {
		guard let project = project,
			  let cachedTasks = storage.fetchCachedTasksForProject(named: project.name) else {
			clearTable()
			clearTasksList()
			return
		}
		tasks = cachedTasks
	}

	private func displayTasks() {
		table.removeRows(at: .init(0..<table.numberOfRows))
		for (index, task) in tasks.enumerated() {
			table.insertRows(at: .init(integer: index),
							 ofType: .taskCell)
			if let taskCellController = table.rowController(at: index)
				as? TaskCellController {
				taskCellController.configureWith(task: task)
			}
		}
	}

	private func clearTasksList() {
		tasks.removeAll()
	}

	private func clearTable() {
		table.removeRows(at: .init(0..<table.numberOfRows))
	}

	private func configureFavoriteView(for project: Project) {
		let color: UIColor = project.favorite ? .orange : .clear
		favoriteView.setTintColor(color)
	}

	// MARK: - Methods

	override func table(_ table: WKInterfaceTable,
						didSelectRowAt rowIndex: Int) {
		pushController(.taskDetails, context: tasks[rowIndex])
	}

	override func refreshScreenState() {
		clearTable()
		switch screenState {
		case .empty:
			table.setHidden(true)
			projectNameLabel.setText("No tasks in \(project?.name ?? "here")")
		case .full:
			table.setHidden(false)
			projectNameLabel.setText(project?.name)
			displayTasks()
		}
	}

	override func storageChangesHandler() {
		fetchTasks()
	}

}
