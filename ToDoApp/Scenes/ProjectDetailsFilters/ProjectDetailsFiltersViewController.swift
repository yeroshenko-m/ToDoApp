//
//  ProjectDetailsFiltersViewController.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 17.03.2021.
//

import UIKit

// MARK: - VC config

struct ProjectDetailsFilterItem {
	let sortDescriptor: TaskSortDescriptors
	let image: UIImage
	var name: String { sortDescriptor.description }
}

struct ProjectDetailsFiltersSection {
	let type: TasksOrderingType
	let items: [ProjectDetailsFilterItem]
}

// MARK: - Protocol

protocol ProjectDetailsFiltersView: BaseView {
	func display(sections: [ProjectDetailsFiltersSection])
}

// MARK: - ViewController

final class ProjectDetailsFiltersViewController: UIViewController {

	// MARK: - IBOutlets

	@IBOutlet weak var tableView: TableView!

	// MARK: - Properties

	var onOrderChangeAction: (() -> Void)?
	private var interactor: ProjectDetailsFiltersInteractor?
	private var selectedOrder: TasksOrderStorage?
	private var sections = [ProjectDetailsFiltersSection]()

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
		configureNavigationItem()
		configureTableView()
		fetchSections()
	}

	// MARK: - Config

	private func configureScene() {
		let view = self
		let presenter = ProjectDetailsFiltersPresenterImpl(view: view)
		let interactor = ProjectDetailsFiltersInteractorImpl(presenter: presenter)
		view.interactor = interactor
	}

	private func configureTableView() {
		tableView.register(SelectOptionCell.nib(),
						   forCellReuseIdentifier: SelectOptionCell.reuseIdentifier)
		tableView.dataSource = self
		tableView.delegate = self
	}

	private func configureNavigationItem() {
		navigationItem.title = R.string.localizable.filtersScreen_title()
		let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
										 target: self,
										 action: #selector(doneButtonHandler))
		let resetButton = UIBarButtonItem(title: R.string.localizable.filtersScreen_resetTitle(),
										  style: .plain,
										  target: self,
										  action: #selector(resetButtonHandler))
		navigationItem.setRightBarButton(doneButton, animated: false)
		navigationItem.setLeftBarButton(resetButton, animated: false)
	}

	// MARK: - Methods

	private func fetchSections() {
		interactor?.fetchSections()
	}

	func setSelectedOrder(_ order: TasksOrderStorage) {
		selectedOrder = order
	}

	// MARK: - Selectors

	@objc
	private func doneButtonHandler() {
		UINotificationFeedbackGenerator().notificationOccurred(.success)
		onOrderChangeAction?()
	}

	@objc
	private func resetButtonHandler() {
		UINotificationFeedbackGenerator().notificationOccurred(.success)
		selectedOrder?.reset()
		tableView.reloadData()
	}

}

// MARK: - ViewController+View

extension ProjectDetailsFiltersViewController: ProjectDetailsFiltersView {

	func display(sections: [ProjectDetailsFiltersSection]) {
		self.sections = sections
		tableView.reloadData()
	}

}

// MARK: - ViewController+TableViewDatasource&Delegate

extension ProjectDetailsFiltersViewController: UITableViewDataSource,
											   UITableViewDelegate {

	func numberOfSections(in tableView: UITableView) -> Int {
		sections.count
	}

	func tableView(_ tableView: UITableView,
				   numberOfRowsInSection section: Int) -> Int {
		sections[section].items.count
	}

	func tableView(_ tableView: UITableView,
				   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let section = sections[indexPath.section]
		let model = SelectOptionCellDisplayObject(menuItemName: section.items[indexPath.row].name,
												  detailImage: section.items[indexPath.row].image)
		let cell = tableView.dequeueReusableCell(withModel: model, for: indexPath)
		cell.accessoryType = selectedOrder?.orderOptionName(for: section.type) == model.menuItemName ? .checkmark : .none
		return cell
	}

	func tableView(_ tableView: UITableView,
				   titleForHeaderInSection section: Int) -> String? {
		sections[section].type.header
	}

	func tableView(_ tableView: UITableView,
				   didSelectRowAt indexPath: IndexPath) {
		UISelectionFeedbackGenerator().selectionChanged()
		tableView.deselectRow(at: indexPath, animated: false)
		let menuSection = sections[indexPath.section]
		selectedOrder?.setOrdering(menuSection.type, to: menuSection.items[indexPath.row].sortDescriptor)
		tableView.reloadData()
	}

	func tableView(_ tableView: UITableView,
				   heightForRowAt indexPath: IndexPath) -> CGFloat {
		self.tableView.tableViewRowHeight
	}

}
