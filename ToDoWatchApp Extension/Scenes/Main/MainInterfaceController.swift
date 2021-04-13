//
//  MainInterfaceController.swift
//  ToDoWatchApp Extension
//
//  Created by Mykhailo Yeroshenko on 08.04.2021.
//

import WatchKit

final class MainInterfaceController: BaseInterfaceController {

	// MARK: - IBOutlets

	@IBOutlet weak var emptyViewGroup: WKInterfaceGroup!
	@IBOutlet weak var emptyViewImage: WKInterfaceImage!
	@IBOutlet weak var emptyViewTitleLabel: WKInterfaceLabel!
	@IBOutlet private weak var table: WKInterfaceTable!

	// MARK: - Properties

	private var menuItems = [MainMenuItem]()
	private let storage = WatchStorageManager.shared

	// MARK: - Lifecycle

	override func awake(withContext context: Any?) {
		super.awake(withContext: context)
		configureMenuItems()
		configureTable()
		subscribeForLoginNotification()
	}

	override func willActivate() {
		super.willActivate()
		validateAuthState()
	}
	
	// MARK: - Config

	private func configureMenuItems() {
		menuItems = [.init(name: "Projects",
						   image: UIImage(systemName: "square.stack.3d.up.fill")),
					 .init(name: "Tasks",
						   image: UIImage(systemName: "checkmark.circle.fill")),
					 .init(name: "Schedule",
						   image: UIImage(systemName: "calendar"))]
	}

	private func configureTable() {
		for (index, item) in menuItems.enumerated() {
			table.insertRows(at: .init(integer: index), ofType: .mainMenuCell)
			if let row = table.rowController(at: index) as? MainMenuCellController {
				row.configureWith(image: item.image, text: item.name)
			}
		}
	}

	// MARK: - Methods

	override func table(_ table: WKInterfaceTable,
						didSelectRowAt rowIndex: Int) {
		switch rowIndex {
		case 0:
			pushController(.projectsList, context: nil)
		case 1:
			pushController(.taskList, context: nil)
		case 2:
			pushController(.schedule, context: nil)
		default:
			return
		}
	}

	private func subscribeForLoginNotification() {
		notificationCenter.addObserver(self,
									   selector: #selector(loginHandler),
									   name: .UserLoggedIn,
									   object: nil)
	}

	private func validateAuthState() {
		let isAuthorized = storage.fetchAuthData()
		if isAuthorized {
			loginHandler()
		} else {
			logoutHandler()
		}
	}

	@objc
	func loginHandler() {
		table.setHidden(false)
		emptyViewGroup.setHidden(true)
	}

	override func logoutHandler() {
		super.logoutHandler()
		table.setHidden(true)
		emptyViewGroup.setHidden(false)
		emptyViewTitleLabel.setText("Login on your iPhone")
	}

}
