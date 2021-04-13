//
//  ProjectDetailsViewController.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 01.02.2021.
//

import UIKit

// MARK: - Protocol

protocol ProjectDetailsView: BaseView {
	func display(tasks: [Task])
	func displaySearch(tasks: [Task])
	func endRefreshing()
}

// MARK: - ViewController

final class ProjectDetailsViewController: BaseViewController {
	
	// MARK: - IBOutlets

	@IBOutlet private weak var tableView: TableView!

	// MARK: - Properties

	var onAddTaskAction: ((Project) -> Void)?
	var onEditTaskAction: ((Task) -> Void)?
	var onChangeListOrderAction: ((TasksOrderStorage) -> Void)?
	var onShowCellPreviewAction: ((Task) -> UIViewController?)?

	private var interactor: ProjectDetailsInteractor?
	var currentProject: Project? {
		didSet {
			interactor?.project = currentProject
		}
	}
	private var tasks = [Task]()
	private var filteredTasks = [Task]()

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
		configureTableViewRefreshControl()
		configureSearchController(withResultsUpdater: self,
								  searchBarPlaceholder: R.string.localizable.searchBar_task())
		configureQuickAddItemButton(on: view, actionTarget: self)
		configureNavigationItem()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		fetchTasksForCurrentProject()
	}
	
	// MARK: - Config

	private func configureScene() {
		let view = self
		let presenter = ProjectDetailsPresenterImpl(view: view)
		let interactor = ProjectDetailsInteractorImpl(presenter: presenter,
													  projectsService: ProjectsService.shared,
													  tasksService: TasksService.shared)
		view.interactor = interactor
	}

	private func configureTableViewRefreshControl() {
		let refreshControl = UIRefreshControl()
		refreshControl.addTarget(self,
								 action: #selector(refreshProjectTasks),
								 for: .valueChanged)
		tableView.refreshControl = refreshControl
	}
	
	private func configureTableView() {
		tableView.register(TaskCell.nib(),
						   forCellReuseIdentifier: TaskCell.reuseIdentifier)
		tableView.dataSource = self
		tableView.delegate = self
		tableView.setNormalTopInset()
	}

	private func configureNavigationItem() {
		navigationItem.title = currentProject?.name
		let filterBarItem = UIBarButtonItem(image: R.image.sort(),
											style: .plain,
											target: self,
											action: #selector(filterButtonSelector))
		guard let currentItem = navigationItem.rightBarButtonItem
		else {
			navigationItem.rightBarButtonItem = filterBarItem
			return
		}
		navigationItem.rightBarButtonItems = [currentItem, filterBarItem]
	}

	// MARK: - Configuring contextual actions

	private func configureContextualDeleteAction(forCellAt indexPath: IndexPath) -> UIContextualAction {
		let deleteAction = UIContextualAction(style: .destructive,
											  title: R.string.localizable.tableView_contextualactionDelete()) { [weak self] (_, _, completionHandler) in
			guard let self = self else { return }
			self.displayAlert(withTitle: R.string.localizable.editTaskScreen_deleteConfirmationTitle(),
							  actionButtonTitle: R.string.localizable.projectsListScreen_alertConfirmDeletionButton()) { _ in
				self.interactor?.delete(task: self.tasks[indexPath.row])
			}
				completionHandler(true)
		}
		deleteAction.backgroundColor = .systemRed
		deleteAction.image = R.image.remove()?.withRenderingMode(.alwaysTemplate)
		return deleteAction
	}

	private func configureContextualEditAction(forCellAt indexPath: IndexPath) -> UIContextualAction {
		let editAction = UIContextualAction(style: .normal,
											title: R.string.localizable.tableView_contextualactionEdit()) { [weak self] (_, _, completionHandler) in
			guard let self = self else { return }
			self.onEditTaskAction?(self.tasks[indexPath.row])
			completionHandler(true)
		}
		editAction.backgroundColor = .systemYellow
		editAction.image = R.image.edit()?.withRenderingMode(.alwaysTemplate)
		return editAction
	}

	// MARK: - Configuring UIActions

	func configureEditTaskUIAction(for selectedTask: Task) -> UIAction {
		let editAction = UIAction(title: R.string.localizable.tableView_contextualactionEdit(),
								  image: R.image.edit()?.withRenderingMode(.alwaysTemplate)) { [weak self] _ in
			guard let self = self else { return }
			self.onEditTaskAction?(selectedTask)
		}
		return editAction
	}

	func configureCloseTaskAction(for selectedTask: Task) -> UIAction {
		let closeAction = UIAction(title: R.string.localizable.tableView_contextualactionClose(),
								   image: R.image.buttonChecked()?.withRenderingMode(.alwaysTemplate),
								   attributes: .destructive) { [weak self] _ in
			self?.interactor?.close(task: selectedTask)
		}
		return closeAction
	}

	func configureDeleteTaskUIAction(for selectedTask: Task) -> UIAction {
		let deleteAction = UIAction(title: R.string.localizable.tableView_contextualactionDelete(),
									image: R.image.remove()?.withRenderingMode(.alwaysTemplate),
									attributes: .destructive) { [weak self] _ in
			guard let self = self else { return }
			self.displayAlert(withTitle: R.string.localizable.projectsListScreen_alertDeleteprojectTitle(),
							  actionButtonTitle: R.string.localizable.projectsListScreen_alertConfirmDeletionButton()) { _ in
				self.activityIndicator.startAnimating()
				self.interactor?.delete(task: selectedTask)
			}
									}
		return deleteAction
	}

	// MARK: - Methods
	
	private func fetchTasksForCurrentProject() {
		guard let project = currentProject else { return }
		activityIndicator.startAnimating()
		interactor?.fetchTasks(for: project)
	}
	
	// MARK: - Selectors
	
	@objc
	override func quickAddItemButtonPressed() {
		super.quickAddItemButtonPressed()
		guard let project = currentProject else { return }
		onAddTaskAction?(project)
	}
	
	@objc
	func refreshProjectTasks() {
		activityIndicator.startAnimating()
		tableView.refreshControl?.endRefreshing()
		guard let project = currentProject
		else {
			activityIndicator.stopAnimating()
			return
		}
		interactor?.fetchTasks(for: project)
	}

	@objc
	private func filterButtonSelector() {
		UISelectionFeedbackGenerator().selectionChanged()
		guard let interactor = interactor else { return }
		onChangeListOrderAction?(interactor.tasksOrderStorage)
	}
	
}

// MARK: - ViewController+View

extension ProjectDetailsViewController: ProjectDetailsView {

	func display(tasks: [Task]) {
		tableView.refreshControl?.endRefreshing()
		endRefreshing()
		if self.tasks != tasks {
			self.tasks = tasks
			tableView.reloadData()
		}
	}

	func displaySearch(tasks: [Task]) {
		endRefreshing()
		filteredTasks = tasks
		tableView.reloadData()
	}

	func endRefreshing() {
		activityIndicator.stopAnimating()
		tableView.reloadData()
	}

}

// MARK: - ViewController+TableViewDataSource&Delegate

extension ProjectDetailsViewController: UITableViewDataSource,
										UITableViewDelegate {
	
	func numberOfSections(in tableView: UITableView) -> Int { 1 }
	
	func tableView(_ tableView: UITableView,
				   numberOfRowsInSection section: Int) -> Int {
		let activeTasks = isSearching ? filteredTasks : tasks
		if activeTasks.isEmpty {
			tableView.setEmptyView(title: R.string.localizable.tableview_noTasksTitle(),
								   message: R.string.localizable.tableview_noTasksMessage())
		} else {
			tableView.restore()
		}
		return activeTasks.count
	}
	
	func tableView(_ tableView: UITableView,
				   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let task = isSearching ? filteredTasks[indexPath.row] : tasks[indexPath.row]
		let model = TaskCellDisplayObject(task: task)
		guard let cell = tableView.dequeueReusableCell(withModel: model,
													   for: indexPath) as? TaskCell
		else { return UITableViewCell() }
		cell.delegate = self
		return cell
	}
	
	func tableView(_ tableView: UITableView,
				   didSelectRowAt indexPath: IndexPath) {
		UISelectionFeedbackGenerator().selectionChanged()
		tableView.deselectRow(at: indexPath, animated: true)
		// TODO: Implement Task Overview screen
	}

	// MARK: - Tableview actions
	
	func tableView(_ tableView: UITableView,
				   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let deleteAction = configureContextualDeleteAction(forCellAt: indexPath)
		return UISwipeActionsConfiguration(actions: [deleteAction])
	}
	
	func tableView(_ tableView: UITableView,
				   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let editAction = configureContextualEditAction(forCellAt: indexPath)
		return UISwipeActionsConfiguration(actions: [editAction])
	}
	
	func tableView(_ tableView: UITableView,
				   contextMenuConfigurationForRowAt indexPath: IndexPath,
				   point: CGPoint) -> UIContextMenuConfiguration? {
		let activeTasks =  isSearching ? filteredTasks : tasks
		let selectedTask = activeTasks[indexPath.row]
		
		return UIContextMenuConfiguration(identifier: indexPath as NSCopying) { () -> UIViewController? in
			self.onShowCellPreviewAction?(selectedTask)
		} actionProvider: { [weak self] _ -> UIMenu? in
			guard let self = self else { return nil }
			let editAction = self.configureEditTaskUIAction(for: selectedTask)
			let deleteAction = self.configureDeleteTaskUIAction(for: selectedTask)
			let closeAction = self.configureCloseTaskAction(for: selectedTask)
			let children = [editAction, closeAction, deleteAction]
			
			return UIMenu(title: selectedTask.name,
						  options: .displayInline,
						  children: children)
		}
	}
	
	func tableView(_ tableView: UITableView,
				   willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration,
				   animator: UIContextMenuInteractionCommitAnimating) {
		guard let indexPath = configuration.identifier as? IndexPath else { return }
		
		let activeTasks =  isSearching ? filteredTasks : tasks
		let selectedTask = activeTasks[indexPath.row]
		
		animator.addCompletion {
			self.onEditTaskAction?(selectedTask)
		}
	}

}

// MARK: - ViewController+TaskCellDelegate

extension ProjectDetailsViewController: TaskCellDelegate {

	func closeTaskButtonPressed(_ sender: UITableViewCell) {
		guard
			let cell = sender as? TaskCell,
			let taskIndexPath = tableView.indexPath(for: cell)
		else { return }
		let task = isSearching ? filteredTasks[taskIndexPath.row] : tasks[taskIndexPath.row]
		interactor?.close(task: task)
	}

}

// MARK: - ViewController+SearchDelegate

extension ProjectDetailsViewController: UISearchResultsUpdating {

	func updateSearchResults(for searchController: UISearchController) {
		guard let text = searchController.searchBar.text else { return }
		guard let project = currentProject else { return }
		interactor?.searchTask(by: text, for: project)
	}

}
