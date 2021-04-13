//
//  TaskDetailsInterfaceController.swift
//  ToDoWatchApp Extension
//
//  Created by Mykhailo Yeroshenko on 08.04.2021.
//

import WatchKit

final class TaskDetailsInterfaceController: BaseInterfaceController {

	// MARK: - IBOutlets

	@IBOutlet private weak var taskNameLabel: WKInterfaceLabel!

	@IBOutlet weak var generalInfoGroup: WKInterfaceGroup!

	@IBOutlet private weak var dueGroup: WKInterfaceGroup!
	@IBOutlet private weak var dueTitleLabel: WKInterfaceLabel!
	@IBOutlet private weak var dueDetailLabel: WKInterfaceLabel!
	@IBOutlet weak var outdatedLabel: WKInterfaceLabel!

	@IBOutlet private weak var priorityGroup: WKInterfaceGroup!
	@IBOutlet private weak var priorityTitleLabel: WKInterfaceLabel!
	@IBOutlet private weak var priorityDetailLabel: WKInterfaceLabel!

	@IBOutlet weak var relatedProjectTitleLabel: WKInterfaceLabel!
	@IBOutlet weak var relatedProjectDetailLabel: WKInterfaceLabel!

	// MARK: - Properties

	private var task: Task? {
		didSet {
			screenState = task == nil ? .empty : .full
		}
	}
	private let storage = WatchStorageManager.shared

	// MARK: - Lifecycle

	override func awake(withContext context: Any?) {
		super.awake(withContext: context)

		if let selectedTask = context as? Task {
			task = selectedTask
		}
		
	}

	// MARK: - Config

	private func displayTaskInfo() {
		guard let currentTask = task else {
			task = nil
			return
		}
		taskNameLabel.setText(currentTask.name)
		configurePriorityGroup(for: currentTask)
		configureDueGroup(for: currentTask)
		relatedProjectDetailLabel.setText(task?.projectName)
	}

	private func configureDueGroup(for task: Task) {
		guard let dateString = task.due,
			  !dateString.isEmpty else {
			dueGroup.setHidden(true)
			return
		}

		if task.isOutdated {
			dueTitleLabel.setTextColor(TodoistColor.red.value)
			dueDetailLabel.setTextColor(TodoistColor.red.value)
			outdatedLabel.setHidden(false)
			outdatedLabel.setText("Outdated")
		}

		let formattedDateString = DateFormatter().dateTimeString(from: dateString)
		dueDetailLabel.setText(formattedDateString)
	}

	private func configurePriorityGroup(for task: Task) {
		var description: String
		var color: UIColor

		switch task.priority {
		case 1:
			description = "Default"
			color = TodoistColor.lightGray.value
		case 2:
			description = "Normal"
			color = TodoistColor.blue.value
		case 3:
			description = "Medium"
			color = TodoistColor.orange.value
		case 4:
			description = "High"
			color = TodoistColor.red.value
		default:
			description = ""
			color = TodoistColor.lightGray.value
		}
		priorityDetailLabel.setText(description)
		priorityDetailLabel.setTextColor(color)
	}

	// MARK: - Methods

	override func refreshScreenState() {
		switch screenState {
		case .empty:
			generalInfoGroup.setHidden(true)
			taskNameLabel.setText("Task info is not available")
		case .full:
			generalInfoGroup.setHidden(false)
			displayTaskInfo()
		}
	}

	override func storageChangesHandler() {
		guard let currentTask = task else {
			return
		}
		task = storage.fetchCachedTask(witIdentifier: currentTask.id)
	}

}
