//
//  SettingsViewController.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 11.02.2021.
//

import UIKit

// MARK: - Protocol

protocol SettingsView: BaseView {
	func displayLogoutSuccess()
}

// MARK: - ViewController

final class SettingsViewController: BaseViewController {

	// MARK: - IBOutlets

	@IBOutlet private weak var tableView: TableView!

	// MARK: - Properties

	var onLogoutOccured: (() -> Void)?

	private var interactor: SettingsInteractor?

	private let sections = [SectionType.logOut(TableViewSection(header: R.string.localizable.settingsController_logoutSectionHeader(),
																footer: R.string.localizable.settingsController_logoutSectionFooter()))]

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
		navigationItem.title = R.string.localizable.settingsController_title()
    }
    
    // MARK: - Config

	private func configureScene() {
		let view = self
		let presenter = SettingsPresenterImpl(view: view)
		let interactor = SettingsInteractorImpl(presenter: presenter, authService: AuthService())
		view.interactor = interactor
	}

    private func configureTableView() {
        tableView.register(SelectOptionCell.nib(),
                           forCellReuseIdentifier: SelectOptionCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
}

// MARK: - ViewController+View

extension SettingsViewController: SettingsView {

	func displayLogoutSuccess() {
		onLogoutOccured?()
	}

}

// MARK: - ViewController+TableViewDataSource&Delegate

extension SettingsViewController: UITableViewDataSource,
                                  UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int { sections.count }
	
	func tableView(_ tableView: UITableView,
				   numberOfRowsInSection section: Int) -> Int { 1 }
	
	func tableView(_ tableView: UITableView,
				   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let model = SelectOptionCellDisplayObject(menuItemName: R.string.localizable.settingsController_сellLogoutTitle(),
												  detailImage: R.image.logout()!.withRenderingMode(.alwaysTemplate))
		return tableView.dequeueReusableCell(withModel: model, for: indexPath)
	}
	
	func tableView(_ tableView: UITableView,
				   didSelectRowAt indexPath: IndexPath) {
		UISelectionFeedbackGenerator().selectionChanged()
		tableView.deselectRow(at: indexPath, animated: true)
		let sectionType = sections[indexPath.section]
		switch sectionType {
		case .logOut:
			displayAlert(withTitle: R.string.localizable.settingsController_сellLogoutTitle(),
						 actionButtonTitle: R.string.localizable.settingsController_alertLogoutConfirmActionTitle()) { [weak self] _ in
				guard let self = self else { return }
				self.interactor?.logOut()
			}
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
				   heightForRowAt indexPath: IndexPath) -> CGFloat {
		self.tableView.tableViewRowHeight
	}
    
}

// MARK: - ViewController+Sections

extension SettingsViewController {

    enum SectionType {
        case logOut(TableViewSection)
        
        var header: String {
            switch self {
            case .logOut(let model): return model.header
            }
        }
        var footer: String {
            switch self {
            case .logOut(let model): return model.footer
            }
        }
    }

}
