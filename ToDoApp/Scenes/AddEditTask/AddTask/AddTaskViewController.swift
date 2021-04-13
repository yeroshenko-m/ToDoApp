//
//  AddTaskViewController.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 01.02.2021.
//

import UIKit
import Speech

// MARK: - Protocol

protocol AddTaskView: BaseView {
	func displaySuccess()
	func displayRecognized(text: String)
	func displayRecognition(status: SpeechRecognitionStatus)
	func enableActionButtons()
}

// MARK: - ViewController

final class AddTaskViewController: BaseViewController {

	// MARK: - IBOutlets

	@IBOutlet private weak var tableView: TableView!

	// MARK: - Properties

	// Coordinating
	var onFinishAddingTaskAction: (() -> Void)?
	var onShowDatePickerAction: ((Date?) -> Void)?
	var onShowProjectsListAction: ((Project?) -> Void)?
	var onShowPrioritiesListAction: ((Priority) -> Void)?

	// Speech recognition button actions
	var onSpeechRecognitionStartAction: (() -> Void)?
	var onSpeechRecognitionStopAction: (() -> Void)?

	// Variables
	private var interactor: AddTaskInteractor?
	var currentProject: Project?
	private var taskName = String()
	private var taskDueDate: Date?
	private var taskPriority = Priority.low

	private let sections: [AddEditTaskScreenSections] = [
		.taskName(TableViewSection(header: R.string.localizable.editTaskScreen_nameSectionHeader(),
								   footer: R.string.localizable.editTaskScreen_nameSectionFooter())),
		.taskProject(TableViewSection(header: R.string.localizable.editTaskScreen_projectSectionHeader(),
									  footer: R.string.localizable.editTaskScreen_projectSectionFooter())),
		.dueDate(TableViewSection(header: R.string.localizable.editTaskScreen_dateSectionHeader(),
								  footer: R.string.localizable.editTaskScreen_dateSectionFooter())),
		.taskPriority(TableViewSection(header: R.string.localizable.editTaskScreen_prioritySectionHeader(),
									   footer: R.string.localizable.editTaskScreen_prioritySectionFooter()))
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
		let presenter = AddTaskPresenterImpl(view: view)
		let interactor = AddTaskInteractorImpl(presenter: presenter,
											   tasksService: TasksService.shared)
		view.interactor = interactor
	}

	private func configureTableView() {
		tableView.register([TextFieldCell.self,
							SelectOptionCell.self])
		tableView.dataSource = self
		tableView.delegate = self
	}

	private func configureNavigationItem() {
		navigationItem.title = R.string.localizable.editTaskScreen_titleAdd()
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
		guard !taskName.isEmpty else {
			displayAlert(withTitle: R.string.localizable.editProjectScreen_alertEmptyName())
			return
		}

		let newTask = Task(id: 0,
						   name: taskName,
						   projectId: currentProject?.id  ?? 0,
						   created: String(),
						   due: taskDueDate != nil ? DateFormatter().stringRFC3339FromDate(taskDueDate!) : nil,
						   priority: taskPriority.rawValue,
						   projectName: String())

		interactor?.makeNew(task: newTask)
		disableActionButtons()
	}
}

// MARK: - ViewController+View

extension AddTaskViewController: AddTaskView {

	func displaySuccess() {
		UINotificationFeedbackGenerator().notificationOccurred(.success)
		onFinishAddingTaskAction?()
	}

	func displayRecognized(text: String) {
		taskName = text
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

extension AddTaskViewController: UITableViewDataSource,
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
			let model = TextFieldCellDisplayObject(placeholder: R.string.localizable.editTaskScreen_textfieldCellPlaceholder(),
												   text: taskName)
			let cell = tableView.dequeueReusableCell(withModel: model, for: indexPath) as! TextFieldCell
			cell.delegate = self
			return cell
		case .taskProject:
			let model = SelectOptionCellDisplayObject(menuItemName: currentProject?.name ?? R.string.localizable.editTaskScreen_projectCellTitle(),
													  detailImage: R.image.relatedProject()!.withRenderingMode(.alwaysTemplate))
			return tableView.dequeueReusableCell(withModel: model, for: indexPath)
		case .dueDate:
			let itemName = DateFormatter().dateTimeString(from: taskDueDate) ?? R.string.localizable.editTaskScreen_dateCellTitle()
			let model = SelectOptionCellDisplayObject(menuItemName: itemName,
													  detailImage: R.image.calendar()!.withRenderingMode(.alwaysTemplate))
			return tableView.dequeueReusableCell(withModel: model, for: indexPath)
		case .taskPriority:
			let model = SelectOptionCellDisplayObject(menuItemName: taskPriority.description,
													  detailImage: R.image.exclamation()!.withRenderingMode(.alwaysTemplate))
			return tableView.dequeueReusableCell(withModel: model, for: indexPath)
		default: return UITableViewCell()
		}
	}

	func tableView(_ tableView: UITableView,
				   didSelectRowAt indexPath: IndexPath) {
		UISelectionFeedbackGenerator().selectionChanged()
		tableView.deselectRow(at: indexPath, animated: true)
		let sectionType = sections[indexPath.section]
		switch sectionType {
		case .taskName:
			guard let cell = tableView.cellForRow(at: indexPath)
					as? TextFieldCell else { return }
			cell.delegate = self
			cell.textField.becomeFirstResponder()
		case .taskProject:
			onShowProjectsListAction?(currentProject)
		case .dueDate:
			onShowDatePickerAction?(taskDueDate)
		case .taskPriority:
			onShowPrioritiesListAction?(taskPriority)
		default: return
		}
	}

	func tableView(_ tableView: UITableView,
				   heightForRowAt indexPath: IndexPath) -> CGFloat {
		self.tableView.tableViewRowHeight
	}

}

// MARK: - ViewController+Delegate

extension AddTaskViewController: TextFieldCellDelegate,
								 UpdatableWithTaskInfo {

	func setDate(_ date: Date?) {
		taskDueDate = date
		tableView.reloadData()
	}

	func setPriority(_ priority: Priority) {
		taskPriority = priority
		tableView.reloadData()
	}

	func setProject(_ project: Project?) {
		currentProject = project
		tableView.reloadData()
	}

	func textChanged(to text: String) {
		taskName = text
	}

	func speechButtonPressed(on cell: TextFieldCell) {
		guard let interactor = interactor else { return }
		if interactor.isRecognizingSpeech {
			interactor.stopSpeechRecognition()
			onSpeechRecognitionStopAction?()
		} else {
			interactor.startSpeechRecognition()
			onSpeechRecognitionStartAction?()
		}
	}
	
}
