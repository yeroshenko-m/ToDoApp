//
//  EditTaskViewController.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 05.02.2021.
//

import UIKit

// MARK: - Protocol

protocol EditTaskView: BaseView {
	func displaySuccess()
	func displayRecognized(text: String)
	func displayRecognition(status: SpeechRecognitionStatus)
	func enableActionButtons()
}

// MARK: - ViewController

final class EditTaskViewController: BaseViewController {

	// MARK: - IBOutlets

	@IBOutlet private weak var tableView: TableView!

	// MARK: - Properties

	// Coordinating
	var onFinishAddingTaskAction: (() -> Void)?
	var onShowDatePickerAction: ((Date?) -> Void)?
	var onShowPrioritiesListAction: ((Priority) -> Void)?

	// Speech recognition button actions
	var onSpeechRecognitionStartAction: (() -> Void)?
	var onSpeechRecognitionStopAction: (() -> Void)?

	// Variables
	private var interactor: EditTaskInteractor?
	var currentTask: Task? {
		didSet {
			newTaskName = currentTask?.name ?? String()
			newTaskPriority = Priority(rawValue: currentTask?.priority ?? 1)
			taskDueDate = DateFormatter().dateFromRFC3339String(currentTask?.due)
		}
	}
	private var newTaskName = String()
	private var taskDueDate: Date?
	private var newTaskPriority = Priority.low

	private let sections: [AddEditTaskScreenSections] = [
		.taskName(TableViewSection(header: R.string.localizable.editTaskScreen_nameSectionHeader(),
								   footer: R.string.localizable.editTaskScreen_nameSectionFooter())),
		.dueDate(TableViewSection(header: R.string.localizable.editTaskScreen_dateSectionHeader(),
								  footer: R.string.localizable.editTaskScreen_dateSectionFooter())),
		.taskPriority(TableViewSection(header: R.string.localizable.editTaskScreen_prioritySectionHeader(),
									   footer: R.string.localizable.editTaskScreen_prioritySectionFooter())),
		.deleteTask(TableViewSection(header: R.string.localizable.editTaskScreen_deleteSectionHeader(),
									 footer: R.string.localizable.editTaskScreen_deleteSectionFooter()))
	]

	// MARK: - Init

	override init(nibName nibNameOrNil: String?,
				  bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil,
				   bundle: nibBundleOrNil)
		configureScene()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		configureScene()
	}

	// MARK: - VC lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		configureNavigationItem()
		configureTableView()
		if SystemHelper.isRunningOnMobile {
			configureKeyboardDismissing(on: tableView)
		}
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		stopRecognition()
	}

	// MARK: - Config

	private func configureScene() {
		let view = self
		let presenter = EditTaskPresenterImpl(view: view)
		let interactor = EditTaskInteractorImpl(presenter: presenter,
												tasksService: TasksService.shared)
		view.interactor = interactor
	}

	private func configureTableView() {
		tableView.register([TextFieldCell.self,
							SelectOptionCell.self,
							DeleteButtonCell.self])
		tableView.dataSource = self
		tableView.delegate = self
	}

	private func configureNavigationItem() {
		navigationItem.title = R.string.localizable.editTaskScreen_titleEdit()
		let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel,
										   target: self,
										   action: #selector(cancelButtonHandler))

		let saveButton = UIBarButtonItem(barButtonSystemItem: .save,
										 target: self,
										 action: #selector(saveButtonHandler))

		navigationItem.setLeftBarButton(cancelButton,
										animated: false)
		navigationItem.setRightBarButton(saveButton,
										 animated: false)
	}

	private func stopRecognition() {
		onSpeechRecognitionStopAction?()
		tableView.reloadData()
		interactor?.stopSpeechRecognition()
	}

	private func disableActionButtons() {
		navigationItem.rightBarButtonItem?.isEnabled = false
	}

	// MARK: - Selectors

	@objc
	override func hideKeyboard() {
		stopRecognition()
		tableView.endEditing(true)
	}

	@objc
	private func cancelButtonHandler() {
		stopRecognition()
		UISelectionFeedbackGenerator().selectionChanged()
		onFinishAddingTaskAction?()
	}

	@objc
	private func saveButtonHandler() {
		stopRecognition()
		tableView.endEditing(true)
		guard let currentTask = currentTask else { return }
		let updatedTask = Task(id: currentTask.id,
							   name: newTaskName,
							   projectId: currentTask.projectId,
							   created: currentTask.created,
							   due: taskDueDate != nil ? DateFormatter().stringRFC3339FromDate(taskDueDate!) : nil,
							   priority: newTaskPriority.rawValue,
							   projectName: currentTask.projectName)
		interactor?.update(task: updatedTask)
		disableActionButtons()
	}
}

// MARK: - ViewController+View

extension EditTaskViewController: EditTaskView {

	func displaySuccess() {
		UINotificationFeedbackGenerator().notificationOccurred(.success)
		dismiss(animated: true)
	}

	func displayRecognized(text: String) {
		newTaskName = text
		tableView.reloadData()
	}

	func displayRecognition(status: SpeechRecognitionStatus) {
		switch status {
		case .inProgress:
			onSpeechRecognitionStartAction?()
		case .isFinished:
			onSpeechRecognitionStopAction?()
		}
	}

	func enableActionButtons() {
		navigationItem.rightBarButtonItem?.isEnabled = true
	}

}

// MARK: - ViewController+TableViewDataSource&Delegate

extension EditTaskViewController: UITableViewDataSource,
								  UITableViewDelegate {

	func numberOfSections(in tableView: UITableView) -> Int {
		sections.count
	}

	func tableView(_ tableView: UITableView,
				   numberOfRowsInSection section: Int) -> Int { 1 }

	func tableView(_ tableView: UITableView,
				   titleForHeaderInSection section: Int) -> String? {
		sections[section].header
	}

	func tableView(_ tableView: UITableView,
				   titleForFooterInSection section: Int) -> String? {
		sections[section].footer
	}

	func tableView(_ tableView: UITableView,
				   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let sectionType = sections[indexPath.section]
		switch sectionType {
		case .taskName:
			let model = TextFieldCellDisplayObject(placeholder: currentTask?.name ?? String(),
												   text: newTaskName)
			let cell = tableView.dequeueReusableCell(withModel: model, for: indexPath) as! TextFieldCell
			cell.delegate = self
			return cell
		case .dueDate:
			let itemName = DateFormatter().dateTimeString(from: taskDueDate) ?? R.string.localizable.editTaskScreen_dateCellTitle()
			let model = SelectOptionCellDisplayObject(menuItemName: itemName,
													  detailImage: R.image.calendar()!.withRenderingMode(.alwaysTemplate))
			return tableView.dequeueReusableCell(withModel: model, for: indexPath)
		case .taskPriority:
			let model = SelectOptionCellDisplayObject(menuItemName: newTaskPriority.description,
													  detailImage: R.image.exclamation()!.withRenderingMode(.alwaysTemplate))
			return tableView.dequeueReusableCell(withModel: model, for: indexPath)
		case .deleteTask:
			let model = DeleteButtonDisplayObject(buttonTitle: R.string.localizable.editTaskScreen_deleteCellTitle())
			let cell = tableView.dequeueReusableCell(withModel: model, for: indexPath) as! DeleteButtonCell
			cell.delegate = self
			return cell
		default: return UITableViewCell()
		}

	}

	func tableView(_ tableView: UITableView,
				   heightForRowAt indexPath: IndexPath) -> CGFloat {
		self.tableView.tableViewRowHeight
	}

	func tableView(_ tableView: UITableView,
				   didSelectRowAt indexPath: IndexPath) {
		UISelectionFeedbackGenerator().selectionChanged()
		tableView.deselectRow(at: indexPath, animated: true)
		let sectionType = sections[indexPath.section]
		switch sectionType {
		case .taskName:
			guard let cell = tableView.cellForRow(at: indexPath) as? TextFieldCell
			else { return }
			cell.delegate = self
			cell.textField.becomeFirstResponder()
		case .dueDate:
			onShowDatePickerAction?(taskDueDate)
		case .taskPriority:
			onShowPrioritiesListAction?(newTaskPriority)
		default: return
		}
	}

}

// MARK: - ViewController+Delegate

extension EditTaskViewController: TextFieldCellDelegate,
								  DeleteButtonCellDelegate,
								  UpdatableWithTaskInfo {

	func setDate(_ date: Date?) {
		taskDueDate = date
		tableView.reloadData()
	}

	func setPriority(_ priority: Priority) {
		newTaskPriority = priority
		tableView.reloadData()
	}
	
	func textChanged(to text: String) {
		newTaskName = text
		tableView.reloadData()
	}

	func didPressDeleteButton(_ sender: UITableViewCell) {
		guard let selectedTask = currentTask else { return }
		displayAlert(withTitle: R.string.localizable.editTaskScreen_deleteConfirmationTitle(),
					 actionButtonTitle: R.string.localizable.projectsListScreen_alertConfirmDeletionButton()) { _ in
			self.interactor?.delete(task: selectedTask)
		}
	}

	func speechButtonPressed(on cell: TextFieldCell) {
		guard let interactor = interactor else { return }
		if interactor.isRecognizingSpeech {
			interactor.stopSpeechRecognition()
		} else {
			interactor.startSpeechRecognition()
		}
	}
	
}
