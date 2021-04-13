//
//  SelectTaskLabelViewController.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 02.02.2021.
//

import UIKit

// MARK: - Protocol

protocol SelectTaskPriorityView: BaseView {
	func display(priorities: [Priority])
}

// MARK: - ViewController

final class SelectTaskPriorityViewController: BaseViewController {
    
    // MARK: - IBOutlets

    @IBOutlet private weak var tableView: TableView!

    // MARK: - Properties

	var onPriorityChangedAction: ((Priority) -> Void)?
	private var interactor: SelectTaskPriorityInteractor?
    private var priorities = [Priority]()
    var selectedPriority: Priority?

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
        configureBarButtons()
		fetchPriorities()
    }
    
    // MARK: - Config

	private func configureScene() {
		let view = self
		let presenter = SelectTaskPriorityPresenterImpl(view: view)
		let interactor = SelectTaskPriorityInteractorImpl(presenter: presenter)
		view.interactor = interactor
	}

    private func configureTableView() {
        tableView.register(TaskPriorityCell.nib(),
                           forCellReuseIdentifier: TaskPriorityCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
	private func configureBarButtons() {
		let removeButton = UIBarButtonItem(title: R.string.localizable.addEditControllers_resetBarbuttonTitle(),
										   style: .plain,
										   target: self,
										   action: #selector(removeButtonHandler))
		navigationItem.setRightBarButton(removeButton,
										 animated: false)
	}

	// MARK: - Methods

	private func fetchPriorities() {
		activityIndicator.startAnimating()
		interactor?.fetchPriorities()
	}
    
    // MARK: - Selectors

    @objc
	private func removeButtonHandler() {
		onPriorityChangedAction?(.low)
    }

}

// MARK: - ViewController+View

extension SelectTaskPriorityViewController: SelectTaskPriorityView {

	func display(priorities: [Priority]) {
		activityIndicator.stopAnimating()
		self.priorities = priorities
		tableView.reloadData()
	}

}

// MARK: - ViewController+TableViewDataSource&Delegate

extension SelectTaskPriorityViewController: UITableViewDelegate,
											UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
		priorities.count
	}
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let priority = priorities[indexPath.row]
        let model = PriorityCellDisplayObject(priority: priority)
        let cell = tableView.dequeueReusableCell(withModel: model, for: indexPath)
        cell.accessoryType = priority.rawValue == selectedPriority?.rawValue ? .checkmark : .none
        return cell
    }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
		UISelectionFeedbackGenerator().selectionChanged()
		onPriorityChangedAction?(priorities[indexPath.row])
    }

	func tableView(_ tableView: UITableView,
				   heightForRowAt indexPath: IndexPath) -> CGFloat {
		self.tableView.tableViewRowHeight
	}
    
}
