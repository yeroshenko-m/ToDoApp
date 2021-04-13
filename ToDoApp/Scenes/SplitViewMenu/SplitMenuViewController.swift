//
//  SplitMasterViewController.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 06.04.2021.
//

import UIKit

// MARK: - Protocol

protocol SplitMenuView: BaseView {
	func display(menuSections: [SplitMenuScreenSections])
}

// MARK: - ViewController

final class SplitMenuViewController: BaseViewController {

	// MARK: - IBOutlets

	@IBOutlet private weak var tableView: TableView!

	// MARK: - Properties

	private var interactor: SplitMenuInteractor?
	private var menuSections = [SplitMenuScreenSections]()

	var onAllProjectsSectionTapAction: (() -> Void)?
	var onAllTasksSectionTapAction: (() -> Void)?
	var onSettingsSectionTapAction: (() -> Void)?

	/// Index of row need to be selected on first start
	var initiallySelectedRowIndex = 0

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
		configureAppearance()
		fetchSections()
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		setSelectedRowAtStart()
	}

	// MARK: - Config

	private func configureScene() {
		let view = self
		let presenter = SplitMenuPresenterImpl(view: view)
		let interactor = SplitMenuInteractorImpl(presenter: presenter)
		view.interactor = interactor
	}

	private func configureTableView() {
		tableView.register([SelectOptionCell.self])
		tableView.dataSource = self
		tableView.delegate = self
		tableView.setMinimalTopInset()
	}

	private func setSelectedRowAtStart() {
		let indexPath = IndexPath(row: initiallySelectedRowIndex, section: 0)
		tableView.selectRow(at: indexPath,
							animated: false,
							scrollPosition: .none)
	}

	private func configureAppearance() {
		navigationItem.title = "ToDoApp"
		isNetworkStatusBannerEnabled = false
	}

	private func fetchSections() {
		interactor?.fetchSections()
	}

}

// MARK: - ViewController+View

extension SplitMenuViewController: SplitMenuView {

	func display(menuSections: [SplitMenuScreenSections]) {
		self.menuSections = menuSections
		tableView.reloadData()
	}

}

// MARK: - ViewController+TableViewDelegate&DataSource

extension SplitMenuViewController: UITableViewDelegate,
									 UITableViewDataSource {

	func tableView(_ tableView: UITableView,
				   numberOfRowsInSection section: Int) -> Int {
		menuSections.count
	}

	func tableView(_ tableView: UITableView,
				   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let section = menuSections[indexPath.row]
		let model = SelectOptionCellDisplayObject(menuItemName: section.name,
												  detailImage: section.image)
		return tableView.dequeueReusableCell(withModel: model, for: indexPath)
	}

	func tableView(_ tableView: UITableView,
				   didSelectRowAt indexPath: IndexPath) {
		switch menuSections[indexPath.row] {
		case .allProjects:
			onAllProjectsSectionTapAction?()
		case .allTasks:
			onAllTasksSectionTapAction?()
		case .settings:
			onSettingsSectionTapAction?()
		}
	}

	func tableView(_ tableView: UITableView,
				   heightForRowAt indexPath: IndexPath) -> CGFloat {
		self.tableView.tableViewRowHeight
	}

}
