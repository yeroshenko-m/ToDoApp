//
//  AddProjectViewController.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 25.01.2021.
//

import UIKit

// MARK: - Protocol

protocol AddProjectView: BaseView {
	func displaySuccess()
	func displayRecognized(text: String)
	func displayRecognition(status: SpeechRecognitionStatus)
	func enableActionButtons()
}

// MARK: - ViewController

final class AddProjectViewController: BaseViewController {
	
	// MARK: - IBOutlets

	@IBOutlet private weak var tableView: TableView!
	
	// MARK: - Properties

	// Coordinating
	var onFinishAddingProjectAction: (() -> Void)?
	var onColorIdChangeAction: ((Int) -> Void)?

	// Speech recognition button actions
	var onSpeechRecognitionStartAction: (() -> Void)?
	var onSpeechRecognitionStopAction: (() -> Void)?

	// Variables
	private var interactor: AddProjectInteractor?
	private var colorId = TodoistColor.defaultColor.id
	private var name = String()
	private var isFavorite = false
	private var parentProject: Project?

	private let sections: [AddEditProjectScreenSections] = [
		.projectName(TableViewSection(header: R.string.localizable.editProjectScreen_nameSectionHeader(),
									  footer: R.string.localizable.editProjectScreen_nameSectionFooter())),
		.projectColor(TableViewSection(header: R.string.localizable.editProjectScreen_colorSectionHeader(),
									   footer: R.string.localizable.editProjectScreen_colorSectionFooter())),
		.isFavorite(TableViewSection(header: R.string.localizable.editProjectScreen_favoriteSectionHeader(),
									 footer: R.string.localizable.editProjectScreen_favoriteSectionFooter()))
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
	
	// MARK: - VC Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		configureTableView()
		if SystemHelper.isRunningOnMobile {
			configureKeyboardDismissing(on: tableView)
		}
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		configureNavigationItem()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		stopRecognition()
	}
	
	// MARK: - Config

	private func configureScene() {
		let view = self
		let presenter = AddProjectPresenterImpl(view: view)
		let interactor = AddProjectInteractorImpl(presenter: presenter,
												  projectsService: ProjectsService.shared)
		view.interactor = interactor
	}

	private func configureTableView() {
		tableView.register([TextFieldCell.self,
							SelectProjectColorCell.self,
							SelectOptionCell.self,
							ToggleButtonCell.self])
		tableView.dataSource = self
		tableView.delegate = self
	}

	private func configureNavigationItem() {
		navigationItem.title = R.string.localizable.editProjectScreen_titleAdd()
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
		onFinishAddingProjectAction?()
	}

	@objc
	private func saveButtonHandler() {
		stopRecognition()
		tableView.endEditing(true)
		guard !name.isEmpty
		else {
			displayAlert(withTitle: R.string.localizable.editProjectScreen_alertEmptyName())
			return
		}

		let newProject = Project(id: 0,
								 name: name,
								 color: colorId,
								 favorite: isFavorite)
		interactor?.makeNew(project: newProject)
		disableActionButtons()
	}
	
}

// MARK: - ViewController+View

extension AddProjectViewController: AddProjectView {

	func displaySuccess() {
		UINotificationFeedbackGenerator().notificationOccurred(.success)
		onFinishAddingProjectAction?()
	}

	func displayRecognized(text: String) {
		name = text
		tableView.reloadData()
	}

	func displayRecognition(status: SpeechRecognitionStatus) {
		switch status {
		case .inProgress:
			onSpeechRecognitionStartAction?()
			tableView.reloadData()
		case .isFinished:
			onSpeechRecognitionStopAction?()
			tableView.reloadData()
		}
	}

	func enableActionButtons() {
		navigationItem.rightBarButtonItem?.isEnabled = true
	}

}

// MARK: - ViewController+TableViewDataSource&Delegate

extension AddProjectViewController: UITableViewDataSource,
									UITableViewDelegate {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		sections.count
	}
	
	func tableView(_ tableView: UITableView,
				   numberOfRowsInSection section: Int) -> Int { 1 }
	
	func tableView(_ tableView: UITableView,
				   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let sectionType = sections[indexPath.section]
		switch sectionType {
		case .projectName:
			let model = TextFieldCellDisplayObject(placeholder: R.string.localizable.editProjectScreen_textfieldCellPlaceholder(),
												   text: name)
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
		case .deleteProject: return UITableViewCell()
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
		case .projectName:
			if let cell = tableView.cellForRow(at: indexPath) as? TextFieldCell {
				cell.textField.becomeFirstResponder()
			}
		case .projectColor:
			onColorIdChangeAction?(colorId)
		default: return
		}
	}

	func tableView(_ tableView: UITableView,
				   heightForRowAt indexPath: IndexPath) -> CGFloat {
		self.tableView.tableViewRowHeight
	}
	
}

// MARK: - ViewController+Delegate

extension AddProjectViewController: ToggleButtonCellDelegate,
									TextFieldCellDelegate,
									UpdatableWithProjectInfo {
	
	func switchDidChangeState(to state: Bool) {
		isFavorite = state
	}
	
	func textChanged(to text: String) {
		name = text
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
