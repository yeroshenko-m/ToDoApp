//
//  ProjectFiltersViewController.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 16.03.2021.
//

import UIKit

// MARK: - VC config

struct ProjectFilterItem {
	let sortDescriptor: ProjectSortDescriptors
	let image: UIImage
	var name: String { sortDescriptor.description }
}

struct ProjectFiltersSection {
	let type: ProjectsOrderingType
	let items: [ProjectFilterItem]
}

// MARK: - Protocol

protocol ProjectFiltersView: BaseView {
	func display(sections: [ProjectFiltersSection])
}

// MARK: - ViewController

final class ProjectFiltersViewController: UIViewController {

	// MARK: - IBOutlets

	@IBOutlet weak var tableView: TableView!

	// MARK: - Properties

	var onOrderChangeAction: (() -> Void)?
	private var interactor: ProjectFiltersInteractor?
	private var selectedOrder: ProjectsOrderStorage?
	private var sections = [ProjectFiltersSection]()

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
		let presenter = ProjectFiltersPresenterImpl(view: view)
		let interactor = ProjectFiltersInteractorImpl(presenter: presenter)
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

	func setSelectedOrder(_ order: ProjectsOrderStorage) {
		selectedOrder = order
	}

	// MARK: - Selectors

	@objc
	private func doneButtonHandler() {
		UISelectionFeedbackGenerator().selectionChanged()
		onOrderChangeAction?()
	}

	@objc
	private func resetButtonHandler() {
		UISelectionFeedbackGenerator().selectionChanged()
		selectedOrder?.reset()
		tableView.reloadData()
	}

}

// MARK: - ViewController+View

extension ProjectFiltersViewController: ProjectFiltersView {

	func display(sections: [ProjectFiltersSection]) {
		self.sections = sections
		tableView.reloadData()
	}

}

// MARK: - ViewController+TableViewDatasource&Delegate

extension ProjectFiltersViewController: UITableViewDataSource,
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
		tableView.reloadSections(.init(arrayLiteral: indexPath.section), with: .fade)
	}

	func tableView(_ tableView: UITableView,
				   heightForRowAt indexPath: IndexPath) -> CGFloat {
		self.tableView.tableViewRowHeight
	}

}
