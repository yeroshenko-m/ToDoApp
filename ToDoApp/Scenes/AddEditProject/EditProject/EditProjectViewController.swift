//
//  EditProjectViewController.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 07.02.2021.
//

import UIKit

// MARK: - Protocol

protocol EditProjectView: BaseView {
	func displaySuccess()
	func displayRecognized(text: String)
	func displayRecognition(status: SpeechRecognitionStatus)
	func enableActionButtons()
}

// MARK: - ViewController

final class EditProjectViewController: BaseViewController {
	
	// MARK: - IBOutlets

	@IBOutlet private weak var tableView: TableView!

	// MARK: - Properties

	// Coordinating
	var onFinishEditingProjectAction: (() -> Void)?
	var onShowColorsListAction: ((Int) -> Void)?

	// Speech recognition button actions
	var onSpeechRecognitionStartAction: (() -> Void)?
	var onSpeechRecognitionStopAction: (() -> Void)?

	// Variables
	private var interactor: EditProjectInteractor?
	var currentProject: Project? {
		didSet {
			newProjectName = currentProject?.name ?? String()
			isFavorite = currentProject?.favorite ?? false
			colorId = currentProject?.color ?? TodoistColor.defaultColor.id
		}
	}
	private var newProjectName = String()
	private var colorId = TodoistColor.defaultColor.id
	private var isFavorite = false

	private let sections: [AddEditProjectScreenSections] = [
		.projectName(TableViewSection(header: R.string.localizable.editProjectScreen_nameSectionHeader(),
									  footer: R.string.localizable.editProjectScreen_nameSectionFooter())),

		.projectColor(TableViewSection(header: R.string.localizable.editProjectScreen_colorSectionHeader(),
									   footer: R.string.localizable.editProjectScreen_colorSectionFooter())),

		.isFavorite(TableViewSection(header: R.string.localizable.editProjectScreen_favoriteSectionHeader(),
									 footer: R.string.localizable.editProjectScreen_favoriteSectionFooter())),
		.deleteProject(TableViewSection(header: R.string.localizable.editProjectScreen_deleteSectionHeader(),
										footer: R.string.localizable.editProjectScreen_deleteSectionFooter()))

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
		configureTableView()
		configureNavigationItem()
		if SystemHelper.isRunningOnMobile {
			configureKeyboardDismissing(on: tableView)
		}
	}
	
	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		stopRecognition()
	}
	
	// MARK: - Config

	private func configureScene() {
		let view = self
		let presenter = EditProjectPresenterImpl(view: view)
		let interactor = EditProjectInteractorImpl(presenter: presenter,
												   projectsService: ProjectsService.shared)
		view.interactor = interactor
	}

	private func configureTableView() {
		tableView.register([TextFieldCell.self,
							SelectProjectColorCell.self,
							SelectOptionCell.self,
							ToggleButtonCell.self,
							DeleteButtonCell.self])
		tableView.dataSource = self
		tableView.delegate = self
	}
	
	private func configureNavigationItem() {
		navigationItem.title = R.string.localizable.editProjectScreen_titleEdit()
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
		tableView.endEditing(true)
		stopRecognition()
	}
	
	@objc
	private func cancelButtonHandler() {
		stopRecognition()
		UISelectionFeedbackGenerator().selectionChanged()
		onFinishEditingProjectAction?()
	}

	@objc
	private func saveButtonHandler() {
		stopRecognition()
		tableView.endEditing(true)
		guard let currentProject = currentProject else { return }

		let updatedProject = Project(id: currentProject.id,
									 name: newProjectName.isEmpty ? currentProject.name : newProjectName,
									 color: colorId,
									 favorite: isFavorite)
		
		interactor?.update(project: updatedProject)
		disableActionButtons()
	}
	
}

// MARK: - ViewController+View

extension EditProjectViewController: EditProjectView {

	func displaySuccess() {
		UINotificationFeedbackGenerator().notificationOccurred(.success)
		onFinishEditingProjectAction?()
	}

	func displayRecognized(text: String) {
		newProjectName = text
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

extension EditProjectViewController: UITableViewDelegate,
									 UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int { sections.count }
	
	func tableView(_ tableView: UITableView,
				   numberOfRowsInSection section: Int) -> Int { 1 }
	
	func tableView(_ tableView: UITableView,
				   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let sectionType = sections[indexPath.section]
		switch sectionType {
		case .projectName:
			let model = TextFieldCellDisplayObject(placeholder: currentProject?.name ?? String(),
												   text: newProjectName)
			let cell = tableView.dequeueReusableCell(withModel: model,
													 for: indexPath) as! TextFieldCell
			cell.delegate = self
			return cell
		case .projectColor:
			let model = SelectProjectColorCellDisplayObject(menuItemName: R.string.localizable.editProjectScreen_colorCellEmpty(),
															todoistColorPreviewId: colorId)
			return tableView.dequeueReusableCell(withModel: model,
												 for: indexPath)
		case .isFavorite:
			let model = ToggleButtonCellDisplayObject(detailImage: R.image.bookmark1()!.withRenderingMode(.alwaysTemplate),
													  menuItemName: R.string.localizable.editProjectScreen_favoriteCellName(),
													  boolValue: isFavorite)
			let cell = tableView.dequeueReusableCell(withModel: model,
													 for: indexPath) as! ToggleButtonCell
			cell.delegate = self
			return cell
		case .deleteProject:
			let model = DeleteButtonDisplayObject(buttonTitle: R.string.localizable.projectsListScreen_alertConfirmDeletionButton())
			let cell = tableView.dequeueReusableCell(withModel: model, for: indexPath) as! DeleteButtonCell
			cell.delegate = self
			return cell
		}
	}
	
	func tableView(_ tableView: UITableView,
				   titleForHeaderInSection section: Int) -> String? {
		sections[section].header
	}
	
	func tableView(_ tableView: UITableView,
				   titleForFooterInSection section: Int) -> String? {
		sections[section].footer
	}
	
	func tableView(_ tableView: UITableView,
				   didSelectRowAt indexPath: IndexPath) {
		UISelectionFeedbackGenerator().selectionChanged()
		tableView.deselectRow(at: indexPath, animated: true)
		let sectionType = sections[indexPath.section]
		switch sectionType {
		case .projectColor:
			onShowColorsListAction?(colorId)
		default: return
		}
	}

	func tableView(_ tableView: UITableView,
				   heightForRowAt indexPath: IndexPath) -> CGFloat {
		self.tableView.tableViewRowHeight
	}
	
}

// MARK: - ViewController+Delegate

extension EditProjectViewController: ToggleButtonCellDelegate,
									 TextFieldCellDelegate,
									 DeleteButtonCellDelegate,
									 UpdatableWithProjectInfo {
	
	func switchDidChangeState(to state: Bool) {
		isFavorite = state
	}
	
	func textChanged(to text: String) {
		newProjectName = text
	}
	
	func didPressDeleteButton(_ sender: UITableViewCell) {
		guard let selectedProject = currentProject else { return }
		displayAlert(withTitle: R.string.localizable.projectsListScreen_alertDeleteprojectTitle(),
					 actionButtonTitle: R.string.localizable.projectsListScreen_alertConfirmDeletionButton()) { _ in
			self.interactor?.delete(project: selectedProject)
		}
	}

	func setColor(id: Int) {
		colorId = id
		tableView.reloadData()
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
