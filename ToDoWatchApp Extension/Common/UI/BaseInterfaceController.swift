//
//  BaseInterfaceController.swift
//  ToDoWatchApp Extension
//
//  Created by Mykhailo Yeroshenko on 10.04.2021.
//

import WatchKit
import Foundation

class BaseInterfaceController: WKInterfaceController {

	// MARK: - Screen state

	enum ScreenState {
		case empty, full
	}

	// MARK: - Properties

	var screenState: ScreenState = .empty {
		didSet {
			refreshScreenState()
		}
	}

	let notificationCenter = NotificationCenter.default

	// MARK: - Lifecycle

	override func awake(withContext context: Any?) {
		super.awake(withContext: context)
		subscribeForDataChanges()
		storageChangesHandler()
		subscribeForLogoutNotification()
	}

	override func didDeactivate() {
		super.didDeactivate()
	}

	// MARK: - Config

	private func subscribeForDataChanges() {
		notificationCenter.addObserver(self, selector: #selector(storageChangesHandler),
									   name: .StorageDataDidChange,
									   object: nil)
	}

	private func subscribeForLogoutNotification() {
		notificationCenter.addObserver(self,
									   selector: #selector(logoutHandler),
									   name: .UserLoggedOut,
									   object: nil)
	}

	// MARK: - Methods

	/// By default has empty implementation.
	/// Override and provide some logic to be executed on screen state change
	func refreshScreenState() {}

	/// By default has empty implementation.
	/// Override and provide some logic to be executed on storage data change
	@objc
	func storageChangesHandler() {}

	@objc
	func logoutHandler() {
		popToRootController()
	}

}
