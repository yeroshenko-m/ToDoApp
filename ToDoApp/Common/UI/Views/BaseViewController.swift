//
//  BaseViewController.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 05.03.2021.
//

import UIKit

class BaseViewController: UIViewController {

	enum ContentInsetType {
		case extended, normal
	}

	// MARK: - Constants

	private let reachabilityManager: ReachabilityManager
	private let notificationCenter: NotificationCenter
	lazy var activityIndicator = ActivityView(view: view)
	var banner: NoNetworkView?
	var isNetworkStatusBannerEnabled = true
	let quickAddItemButton = AddButton()

	var searchBarIsEmpty: Bool {
		guard let searchText = navigationItem.searchController?.searchBar.text
		else { return false }
		return searchText.isEmpty
	}

	var isSearching: Bool {
		guard let searchController = navigationItem.searchController else { return false }
		return searchController.isActive && !searchBarIsEmpty
	}

	// MARK: - Init

	override init(nibName nibNameOrNil: String?,
				  bundle nibBundleOrNil: Bundle?) {
		reachabilityManager = ReachabilityManager.shared
		notificationCenter = NotificationCenter.default
		super.init(nibName: nibNameOrNil,
				   bundle: nibBundleOrNil)
	}

	required init?(coder: NSCoder) {
		reachabilityManager = ReachabilityManager.shared
		notificationCenter = NotificationCenter.default
		super.init(coder: coder)
	}

	// MARK: - VC Lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		configReachability()
		banner = NoNetworkView(frame: NoNetworkView.frame)
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		if reachabilityManager.isUnreachable {
			configureViewInset(type: .extended)
			banner?.show(on: view, animated: false)
		}
	}

	// MARK: - Config

	func configureQuickAddItemButton(on containerView: UIView, actionTarget target: Any?) {
		if SystemHelper.isRunningOnMobile {
		quickAddItemButton.pinTo(containerView)
		quickAddItemButton.addTarget(self, action: #selector(quickAddItemButtonPressed),
									 for: .touchUpInside)
		} else if SystemHelper.isRunningOnMacCatalyst {
			let addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
												   target: target,
												   action: #selector(quickAddItemButtonPressed))
			navigationItem.rightBarButtonItem = addBarButtonItem
		}
	}

	func configureKeyboardDismissing(on view: UIView) {
		let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
		tapGesture.cancelsTouchesInView = false
		tapGesture.delegate = self
		view.addGestureRecognizer(tapGesture)
	}

	func configureSearchController(withResultsUpdater updater: UISearchResultsUpdating,
								   searchBarPlaceholder: String) {
		let searchController = SearchController(searchResultsController: nil)
		searchController.configure(placeholder: searchBarPlaceholder)
		searchController.searchResultsUpdater = updater
		navigationItem.searchController = searchController
		navigationItem.hidesSearchBarWhenScrolling = true
	}

	private func configReachability() {
		notificationCenter.addObserver(self, selector: #selector(reachabilityChanged(notification:)),
									   name: .reachabilityChanged, object: nil)
	}

	private func configureViewInset(type: ContentInsetType) {
		for subview in view.subviews {
			if let tableView = subview as? TableView {
				switch type {
				case .extended:
					tableView.setAdditionalTopInset()
				case .normal:
					tableView.setNormalTopInset()
				}
			}
		}
	}

	// MARK: - Methods

	func displayAlert(withTitle alertTitle: String,
					  alertMessage message: String? = nil,
					  actionButtonTitle title: String? = nil,
					  action handler: ((UIAlertAction) -> Void)? = nil) {
		UINotificationFeedbackGenerator().notificationOccurred(.error)
		let alertVC = UIAlertController(title: alertTitle,
										message: message,
										preferredStyle: .alert)

		let cancelAction = UIAlertAction(title: R.string.localizable.projectsListScreen_alertCancelDeletionButton(),
										 style: .cancel)
		alertVC.addAction(cancelAction)

		if let actionButtonTitle = title {
			let confirmAction = UIAlertAction(title: actionButtonTitle,
											  style: .destructive,
											  handler: handler)
			alertVC.addAction(confirmAction)
		}
		present(alertVC, animated: true)
	}

	// MARK: - Selector

	@objc
	private func reachabilityChanged(notification: Notification) {
		guard isNetworkStatusBannerEnabled else { return }
		switch reachabilityManager.connectionType {
		case .unavailable:
			configureViewInset(type: .extended)
			banner?.show(on: view, animated: true)
			UINotificationFeedbackGenerator().notificationOccurred(.success)
		case .cellular, .wifi:
			UINotificationFeedbackGenerator().notificationOccurred(.success)
			banner?.hide(completion: {
				self.configureViewInset(type: .normal)
			})
		default: return
		}
	}

	/// By default has empty implementation
	/// Override and set actions for keyboard dismissing
	@objc
	func hideKeyboard() {}

	/// By default has empty implementation with haptic feedback
	/// Override and set action for button
	@objc
	func quickAddItemButtonPressed() {
		UISelectionFeedbackGenerator().selectionChanged()
	}

}

extension BaseViewController: UIGestureRecognizerDelegate {

	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
						   shouldReceive touch: UITouch) -> Bool {
		if touch.view is SpeechRecordButton {
			return false
		} else if touch.view?.superview is UITableViewCell {
			return false
		} else {
			return true
		}
	}

}
