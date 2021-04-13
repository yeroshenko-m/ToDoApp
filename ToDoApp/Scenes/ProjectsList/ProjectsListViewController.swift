//
//  ProjectsListViewController.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 26.01.2021.
//

import UIKit

// MARK: - Protocol

protocol ProjectsListView: BaseView {
	func display(projectsList: [Project])
	func displaySearch(projectsList: [Project])
	func endRefreshing()
}

// MARK: - ViewController

final class ProjectsListViewController: BaseViewController {

	// MARK: - IBOutlets

	@IBOutlet private weak var tableView: TableView!

	// MARK: - Properties

	private var interactor: ProjectsListInteractor?

	var onAddProjectAction: (() -> Void)?
	var onEditProjectAction: ((Project) -> Void)?
	var onShowProjectDetailsAction: ((Project) -> Void)?
	var onChangeListOrderAction: ((ProjectsOrderStorage) -> Void)?
	var onShowCellPreviewAction: ((Project) -> UIViewController?)?

	private var projects = [Project]()
	private var searchResults = [Project]()

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
								  searchBarPlaceholder: R.string.localizable.searchBar_project())
		configureQuickAddItemButton(on: view, actionTarget: self)
		configureNavigationItem()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		fetchProjects()
	}
	
	// MARK: - Config

	private func configureScene() {
		let view = self
		let presenter = ProjectsListPresenterImpl(view: view)
		let interactor = ProjectsListInteractorImpl(projectsService: ProjectsService.shared,
													presenter: presenter)
		view.interactor = interactor
	}

	private func configureTableViewRefreshControl() {
		let refreshControl = UIRefreshControl()
		refreshControl.addTarget(self, action: #selector(refreshProjectsList),
								 for: .valueChanged)
		tableView.refreshControl = refreshControl
	}

	private func configureTableView() {
		tableView.register(ProjectCell.nib(),
						   forCellReuseIdentifier: ProjectCell.reuseIdentifier)
		tableView.dataSource = self
		tableView.delegate = self
		tableView.setNormalTopInset()
	}

	private func configureNavigationItem() {
		navigationItem.title = R.string.localizable.projectsListScreen_title()
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

	private func configureContextualFavoriteAction(forCellAt indexPath: IndexPath) -> UIContextualAction {
		let action = UIContextualAction(style: .normal, title: nil) {[weak self] (_, _, handler) in
			guard let self = self else { return }
			self.activityIndicator.startAnimating()
			let project = self.projects[indexPath.row]
			let updatedProject = Project(id: project.id,
										 name: project.name,
										 color: project.color,
										 favorite: !project.favorite)
			self.interactor?.update(project: updatedProject)
			handler(true)
		}
		action.backgroundColor = .systemOrange
		action.image = (projects[indexPath.row].favorite ? R.image.bookmarkRemove() : R.image.bookmarkAdd())?
			.withRenderingMode(.alwaysTemplate)
		return action
	}

	private func configureContextualDeleteAction(forCellAt indexPath: IndexPath) -> UIContextualAction {
		let deleteAction = UIContextualAction(style: .normal,
											  title: R.string.localizable.tableView_contextualactionDelete()) {[weak self] (_, _, handler) in
			guard let self = self else { return }
			self.displayAlert(withTitle: R.string.localizable.projectsListScreen_alertDeleteprojectTitle(),
							  actionButtonTitle: R.string.localizable.projectsListScreen_alertConfirmDeletionButton()) { _ in
				self.activityIndicator.startAnimating()
				self.interactor?.delete(project: self.projects[indexPath.row])
			}
												handler(true)
		}
		deleteAction.backgroundColor = .systemRed
		deleteAction.image = R.image.remove()?.withRenderingMode(.alwaysTemplate)
		return deleteAction
	}

	private func configureContextualEditAction(forCellAt indexPath: IndexPath) -> UIContextualAction {
		let selectedProject = projects[indexPath.row]
		let editAction = UIContextualAction(style: .normal,
											title: R.string.localizable.tableView_contextualactionEdit()) { [weak self] (_, _, completionHandler) in
			guard let self = self else { return }
			self.onEditProjectAction?(selectedProject)
			completionHandler(true)
		}
		editAction.backgroundColor = .systemYellow
		editAction.image = R.image.edit()?.withRenderingMode(.alwaysTemplate)
		return editAction
	}

	// MARK: - Configuring UIActions

	private func configureEditUIAction(for selectedProject: Project) -> UIAction {
		let editAction = UIAction(title: R.string.localizable.tableView_contextualactionEdit(),
								  image: R.image.edit()?.withTintColor(.systemYellow,
																	   renderingMode: .alwaysTemplate)) { [weak self] _ in
			guard let self = self else { return }
			self.onEditProjectAction?(selectedProject)
		}
		return editAction
	}

	private func configureDeleteUIAction(for selectedProject: Project) -> UIAction {
		let deleteAction = UIAction(title: R.string.localizable.tableView_contextualactionDelete(),
									image: R.image.remove()?.withRenderingMode(.alwaysTemplate),
									attributes: .destructive) { [weak self] _ in
			guard let self = self else { return }
			self.displayAlert(withTitle: R.string.localizable.projectsListScreen_alertDeleteprojectTitle(),
							  actionButtonTitle: R.string.localizable.projectsListScreen_alertConfirmDeletionButton()) { _ in
				self.activityIndicator.startAnimating()
				self.interactor?.delete(project: selectedProject)
			}
									}
		return deleteAction
	}

	private func configureFavoriteUIAction(for selectedProject: Project) -> UIAction {
		let favoriteImage = selectedProject.favorite ?
			R.image.bookmarkRemove()?.withRenderingMode(.alwaysTemplate)
			: R.image.bookmarkAdd()?.withRenderingMode(.alwaysTemplate)
		let favoriteTitle = selectedProject.favorite ?
			R.string.localizable.tableView_contextualactionMakeNotFavorite() :
			R.string.localizable.tableView_contextualactionMakeFavorite()
		let favoriteAction = UIAction(title: favoriteTitle,
									  image: favoriteImage?.withRenderingMode(.alwaysTemplate)) { [weak self] _ in
			guard let self = self else { return }
			self.activityIndicator.startAnimating()
			let updatedProject = Project(id: selectedProject.id,
										 name: selectedProject.name,
										 color: selectedProject.color,
										 favorite: !selectedProject.favorite)
			self.interactor?.update(project: updatedProject)
		}
		return favoriteAction
	}

	// MARK: - Methods

	private func fetchProjects() {
		activityIndicator.startAnimating()
		interactor?.fetchProjects()
	}

	// MARK: - Selectors
	
	@objc
	override func quickAddItemButtonPressed() {
		super.quickAddItemButtonPressed()
		onAddProjectAction?()
	}

	@objc
	func refreshProjectsList() {
		activityIndicator.startAnimating()
		tableView.refreshControl?.endRefreshing()
		interactor?.fetchProjects()
	}

	@objc
	private func filterButtonSelector() {
		UISelectionFeedbackGenerator().selectionChanged()
		guard let interactor = interactor else { return }
		onChangeListOrderAction?(interactor.projectsOrderStorage)
	}

}

// MARK: - ViewController+View

extension ProjectsListViewController: ProjectsListView {

	func display(projectsList: [Project]) {
		endRefreshing()
		projects = projectsList
		tableView.reloadData()
	}

	func displaySearch(projectsList: [Project]) {
		endRefreshing()
		searchResults = projectsList
		tableView.reloadData()
	}

	func endRefreshing() {
		activityIndicator.stopAnimating()
		tableView.reloadData()
	}

}

// MARK: - ViewController+TableViewDelegate

extension ProjectsListViewController: UITableViewDataSource,
									  UITableViewDelegate {

	func numberOfSections(in tableView: UITableView) -> Int { 1 }

	func tableView(_ tableView: UITableView,
				   numberOfRowsInSection section: Int) -> Int {
		let activeProjects = isSearching ? searchResults : projects
		if activeProjects.isEmpty {
			tableView.setEmptyView(title: R.string.localizable.tableview_noProjectsTitle(),
								   message: R.string.localizable.tableview_noProjectsMessage())
		} else {
			tableView.restore()
		}
		return activeProjects.count
	}

	func tableView(_ tableView: UITableView,
				   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let project = isSearching ? searchResults[indexPath.row] : projects[indexPath.row]
		let model = ProjectCellDisplayObject(project: project)
		return tableView.dequeueReusableCell(withModel: model, for: indexPath)
	}

	func tableView(_ tableView: UITableView,
				   didSelectRowAt indexPath: IndexPath) {
		UISelectionFeedbackGenerator().selectionChanged()
		tableView.deselectRow(at: indexPath, animated: true)
		let project = isSearching ? searchResults[indexPath.row] : projects[indexPath.row]
		onShowProjectDetailsAction?(project)
	}

	func tableView(_ tableView: UITableView,
				   canEditRowAt indexPath: IndexPath) -> Bool {
		projects[indexPath.row].name == "Inbox" ? false : true
	}

	// MARK: - Tableview actions

	func tableView(_ tableView: UITableView,
				   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		UISwipeActionsConfiguration(actions: [configureContextualDeleteAction(forCellAt: indexPath),
											  configureContextualFavoriteAction(forCellAt: indexPath)])
	}

	func tableView(_ tableView: UITableView,
				   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		UISwipeActionsConfiguration(actions: [configureContextualEditAction(forCellAt: indexPath)])
	}

	func tableView(_ tableView: UITableView,
				   contextMenuConfigurationForRowAt indexPath: IndexPath,
				   point: CGPoint) -> UIContextMenuConfiguration? {
		let activeProjects =  isSearching ? searchResults : projects
		let selectedProject = activeProjects[indexPath.row]

		return UIContextMenuConfiguration(identifier: indexPath as NSCopying, previewProvider: {
			self.onShowCellPreviewAction?(selectedProject)
		}, actionProvider: { [weak self] _ -> UIMenu? in
			guard let self = self else { return nil }
			let editAction = self.configureEditUIAction(for: selectedProject)
			let deleteAction = self.configureDeleteUIAction(for: selectedProject)
			let favoriteAction = self.configureFavoriteUIAction(for: selectedProject)

			let children = selectedProject.name == "Inbox" ? [] : [editAction, favoriteAction, deleteAction]

			return UIMenu(title: selectedProject.name,
						  options: .displayInline,
						  children: children)
		})
	}

	func tableView(_ tableView: UITableView,
				   willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration,
				   animator: UIContextMenuInteractionCommitAnimating) {
		guard let indexPath = configuration.identifier as? IndexPath else { return }

		let activeProjects =  isSearching ? searchResults : projects
		let selectedProject = activeProjects[indexPath.row]

		animator.addCompletion {
			self.onShowProjectDetailsAction?(selectedProject)

		}
	}

}

// MARK: - ViewController+SearchDelegate

extension ProjectsListViewController: UISearchResultsUpdating,
									  UISearchBarDelegate {

	func updateSearchResults(for searchController: UISearchController) {
		guard let text = searchController.searchBar.text
		else { return }
		interactor?.searchProject(by: text)
	}

	func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
		interactor?.fetchProjects()
	}

}
