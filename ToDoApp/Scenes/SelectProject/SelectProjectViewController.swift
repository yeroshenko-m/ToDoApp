//
//  SelectProjectViewController.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 28.01.2021.
//

import UIKit

// MARK: - Protocol

protocol SelectProjectView: BaseView {
	func display(projectsList: [Project])
}

// MARK: - ViewController

final class SelectProjectViewController: BaseViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var tableView: TableView!

    // MARK: - Properties

	var onProjectSelectedAction: ((Project) -> Void)?
	private var interactor: SelectProjectInteractor?
    private var projects = [Project]()
    var selectedProject: Project?

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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
		fetchProjectsList()
    }

	// MARK: - Config

	private func configureScene() {
		let view = self
		let presenter = SelectProjectPresenterImpl(view: view)
		let interactor = SelectProjectInteractorImpl(projectsService: ProjectsService.shared,
													 presenter: presenter)
		view.interactor = interactor
	}

	private func configureTableView() {
		tableView.register(ProjectCell.nib(),
						   forCellReuseIdentifier: ProjectCell.reuseIdentifier)
		tableView.dataSource = self
		tableView.delegate = self
    }

	private func fetchProjectsList() {
		activityIndicator.startAnimating()
		interactor?.fetchProjects()
	}

}

// MARK: - ViewController+View

extension SelectProjectViewController: SelectProjectView {
	
	func display(projectsList: [Project]) {
		activityIndicator.stopAnimating()
		projects = projectsList
		tableView.reloadData()
	}

}

// MARK: - ViewController+TableViewDataSource&Delegate

extension SelectProjectViewController: UITableViewDataSource,
									   UITableViewDelegate {

	func tableView(_ tableView: UITableView,
				   numberOfRowsInSection section: Int) -> Int { projects.count }

	func tableView(_ tableView: UITableView,
				   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let project = projects[indexPath.row]
		let model = ProjectCellDisplayObject(project: project)
		let cell = tableView.dequeueReusableCell(withModel: model, for: indexPath)
		cell.accessoryType = project.id == selectedProject?.id ? .checkmark : .none
		return cell
	}

	func tableView(_ tableView: UITableView,
				   didSelectRowAt indexPath: IndexPath) {
		UISelectionFeedbackGenerator().selectionChanged()
		onProjectSelectedAction?(projects[indexPath.row])
	}

}
