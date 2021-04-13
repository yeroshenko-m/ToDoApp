//
//  AllTasksViewController.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 10.02.2021.
//

import UIKit

// MARK: - Protocol

protocol TasksListView: BaseView {
	func display(tasks: [TasksListSection])
	func displaySearch(tasks: [TasksListSection])
	func endRefreshing()
}

// MARK: - ViewController

final class TasksListViewController: BaseViewController {

	// MARK: - IBOutlets

	@IBOutlet private weak var tableView: TableView!

	// MARK: - Properties

	var onAddTaskAction: (() -> Void)?
	var onEditTaskAction: ((Task) -> Void)?
	var onChangeListOrderAction: ((TasksOrderStorage) -> Void)?
	var onShowCellPreviewAction: ((Task) -> UIViewController?)?

	private var interactor: TasksListInteractor?
	private var tasksSections = [TasksListSection]()
	private var filteredTasksSections = [TasksListSection]()

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
		configureTableViewRefreshControl()
		configureSearchController(withResultsUpdater: self,
								  searchBarPlaceholder: R.string.localizable.searchBar_task())
		configureQuickAddItemButton(on: view, actionTarget: self)
		configureNavigationItem()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		fetchAllTasks()
	}

	// MARK: - Config

	private func configureScene() {
		let view = self
		let presenter = TasksListPresenterImpl(view: view)
		let interactor = TasksListInteractorImpl(presenter: presenter,
												 projectsService: ProjectsService.shared,
												tasksService: TasksService.shared)
		view.interactor = interactor
	}

	private func configureTableViewRefreshControl() {
		let refreshControl = UIRefreshControl()
		refreshControl.addTarget(self, action: #selector(refreshTasksList),
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
		navigationItem.title = R.string.localizable.allTasksController_title()
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

	private func configureDeleteAction(forCellAt indexPath: IndexPath) -> UIContextualAction {
		let deleteAction = UIContextualAction(style: .destructive,
											  title: R.string.localizable.tableView_contextualactionDelete()) { [weak self] (_, _, completionHandler) in
			guard let self = self else { return }
			self.displayAlert(withTitle: R.string.localizable.editTaskScreen_deleteConfirmationTitle(),
							  actionButtonTitle: R.string.localizable.tableView_contextualactionDelete()) { _ in
				self.interactor?.delete(task: self.tasksSections[indexPath.section].tasks[indexPath.row])
			}
												completionHandler(true)
		}
		deleteAction.backgroundColor = .systemRed
		deleteAction.image = R.image.remove()?.withRenderingMode(.alwaysTemplate)
		return deleteAction
	}

	private func configureEditAction(forCellAt indexPath: IndexPath) -> UIContextualAction {
		let editAction = UIContextualAction(style: .normal,
											title: R.string.localizable.tableView_contextualactionEdit()) { [weak self] (_, _, completionHandler) in
			guard let self = self else { return }
			let taskToEdit = self.tasksSections[indexPath.section].tasks[indexPath.row]
			self.onEditTaskAction?(taskToEdit)
			completionHandler(true)
		}
		editAction.backgroundColor = .systemYellow
		editAction.image = R.image.edit()?.withRenderingMode(.alwaysTemplate)
		return editAction
	}

	// MARK: - Configuring UIActions

	private func configureEditUIAction(for selectedTask: Task) -> UIAction {
		let editAction = UIAction(title: R.string.localizable.tableView_contextualactionEdit(),
								  image: R.image.edit()?.withRenderingMode(.alwaysTemplate)) { [weak self] _ in
			guard let self = self else { return }
			self.onEditTaskAction?(selectedTask)
		}
		return editAction
	}

	private func configureCloseAction(for selectedTask: Task) -> UIAction {
		let closeAction = UIAction(title: R.string.localizable.tableView_contextualactionClose(),
								   image: R.image.buttonChecked()?.withRenderingMode(.alwaysTemplate),
								   attributes: .destructive) { [weak self] _ in
			self?.interactor?.close(task: selectedTask)
		}
		return closeAction
	}

	private func configureDeleteUIAction(for selectedTask: Task) -> UIAction {
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

	private func fetchAllTasks() {
		activityIndicator.startAnimating()
		interactor?.fetchTasks()
	}

	// MARK: - Selectors

	@objc
	override func quickAddItemButtonPressed() {
		super.quickAddItemButtonPressed()
		onAddTaskAction?()
	}

	@objc
	func refreshTasksList() {
		activityIndicator.startAnimating()
		interactor?.fetchTasks()
		tableView.refreshControl?.endRefreshing()
	}

	@objc
	private func filterButtonSelector() {
		UISelectionFeedbackGenerator().selectionChanged()
		guard let interactor = interactor else { return }
		onChangeListOrderAction?(interactor.tasksOrderStorage)
	}

}

// MARK: - ViewController+View

extension TasksListViewController: TasksListView {

	// TODO: Fix - tableView is called from interactor's delegation method
	func display(tasks: [TasksListSection]) {
		endRefreshing()
		self.tasksSections = tasks
		if isViewLoaded {
			self.tableView.reloadData()
		}
	}

	func displaySearch(tasks: [TasksListSection]) {
		endRefreshing()
		filteredTasksSections = tasks
		tableView.reloadData()
	}

	func endRefreshing() {
		activityIndicator.stopAnimating()
		tableView.reloadData()
	}

}

// MARK: - ViewController+TableViewDataSource&Delegate

extension TasksListViewController: UITableViewDelegate,
								  UITableViewDataSource {

	func numberOfSections(in tableView: UITableView) -> Int {
		let activeSections = isSearching ? filteredTasksSections : tasksSections
		if activeSections.allSectionsAreEmpty {
			tableView.setEmptyView(title: R.string.localizable.tableview_noTasksTitle(),
								   message: R.string.localizable.tableview_noTasksMessage())
		} else {
			tableView.restore()
		}
		return activeSections.count
	}

	func tableView(_ tableView: UITableView,
				   titleForHeaderInSection section: Int) -> String? {
		let activeSections = isSearching ? filteredTasksSections : tasksSections
		return activeSections[section].name
	}

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		self.tableView.tableViewSectionHeight
	}

	func tableView(_ tableView: UITableView,
				   numberOfRowsInSection section: Int) -> Int {
		let activeSections = isSearching ? filteredTasksSections : tasksSections
		return activeSections[section].tasks.count
	}

	func tableView(_ tableView: UITableView,
				   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let task = isSearching ?
			filteredTasksSections[indexPath.section].tasks[indexPath.row] :
			tasksSections[indexPath.section].tasks[indexPath.row]
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
		let deleteAction = configureDeleteAction(forCellAt: indexPath)
		return UISwipeActionsConfiguration(actions: [deleteAction])
	}

	func tableView(_ tableView: UITableView,
				   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let editAction = configureEditAction(forCellAt: indexPath)
		return UISwipeActionsConfiguration(actions: [editAction])
	}

	func tableView(_ tableView: UITableView,
				   contextMenuConfigurationForRowAt indexPath: IndexPath,
				   point: CGPoint) -> UIContextMenuConfiguration? {
		let activeTasks =  isSearching ? filteredTasksSections : tasksSections
		let selectedTask = activeTasks[indexPath.section].tasks[indexPath.row]
		
		return UIContextMenuConfiguration(identifier: indexPath as NSCopying) { () -> UIViewController? in
			self.onShowCellPreviewAction?(selectedTask)
		} actionProvider: { [weak self] _ -> UIMenu? in
			guard let self = self else { return nil }
			let editAction = self.configureEditUIAction(for: selectedTask)
			let deleteAction = self.configureDeleteUIAction(for: selectedTask)
			let closeAction = self.configureCloseAction(for: selectedTask)
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

		let activeTasks =  isSearching ? filteredTasksSections : tasksSections
		let selectedTask = activeTasks[indexPath.section].tasks[indexPath.row]

		animator.addCompletion {
			self.onEditTaskAction?(selectedTask)
		}
	}

}

// MARK: - ViewController+Delegate

extension TasksListViewController: TaskCellDelegate {

	func closeTaskButtonPressed(_ sender: UITableViewCell) {
		guard
			let cell = sender as? TaskCell,
			let taskIndexPath = tableView.indexPath(for: cell)
		else { return }
		let task = isSearching ?
			filteredTasksSections[taskIndexPath.section].tasks[taskIndexPath.row] :
			tasksSections[taskIndexPath.section].tasks[taskIndexPath.row]
		interactor?.close(task: task)
	}

}

// MARK: - ViewController+SearchDelegate

extension TasksListViewController: UISearchResultsUpdating {

	func updateSearchResults(for searchController: UISearchController) {
		guard let text = searchController.searchBar.text else { return }
		interactor?.searchTask(by: text)
	}

}
