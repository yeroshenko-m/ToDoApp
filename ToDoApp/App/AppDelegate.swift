//
//  AppDelegate.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 19.01.2021.
//

import UIKit
import WatchConnectivity

@main
class AppDelegate: UIResponder,
				   UIApplicationDelegate {

	// MARK: - Components

	private let watchConnectivitySession = WCSession.default
	private let projectsService = ProjectsService.shared
	private let tasksService = TasksService.shared
	private let authService = AuthService()
	let notificationCenter = NotificationCenter.default

	// MARK: - API

    func application(_ application: UIApplication,
					 didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		configureAuthNotifications()
		configureConnectivitySession()

		return true

	}
    
    func application(_ application: UIApplication,
					 configurationForConnecting connectingSceneSession: UISceneSession,
					 options: UIScene.ConnectionOptions) -> UISceneConfiguration {

        return UISceneConfiguration(name: "Default Configuration",
									sessionRole: connectingSceneSession.role)

    }
    
    func application(_ application: UIApplication,
					 didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {}

	// MARK: - Config

	private func configureConnectivitySession() {
		if WCSession.isSupported() {
			watchConnectivitySession.delegate = self
			watchConnectivitySession.activate()
		}
	}
    
}

// MARK: - Watch App staff

extension AppDelegate: WCSessionDelegate {

	func session(_ session: WCSession,
				 activationDidCompleteWith activationState: WCSessionActivationState,
				 error: Error?) {
		guard error == nil else {
			print("WCSession activation failed with error: \(String(describing: error?.localizedDescription))")
			return
		}
		updateWatchData()
		print("WCSession activated with state: \(session.activationState.rawValue)")
	}

	func sessionDidBecomeInactive(_ session: WCSession) {
		print(#function)
	}

	func sessionDidDeactivate(_ session: WCSession) {
		print(#function)
		watchConnectivitySession.activate()
	}

	// MARK: - Private implementation

	private func updateWatchData() {

		var watchContext: [String: Any] = [WatchDataTypeSyncKey.tasks: Data.self,
										   WatchDataTypeSyncKey.projects: Data.self]
		let group = DispatchGroup()

		watchContext["login"] = authService.isAuthorized ? "LoggedIn" : "LoggedOut"

		group.enter()
		tasksService.fetchCachedTasks(sortedBy: [.createdAscending, .nameAZ]) { result in
			switch result {
			case .failure(let error):
				print(error.localizedDescription)
			case .success(let tasks):
				if let tasksData = try? JSONEncoder().encode(tasks) {
					watchContext[WatchDataTypeSyncKey.tasks] = tasksData
				}
			}
			group.leave()
		}

		group.enter()
		projectsService.fetchCachedProjects(sortedBy: [.favoriteFirst, .nameAZ]) { result in
			switch result {
			case .failure(let error):
				print(error.localizedDescription)
			case .success(let projects):
				if let projectsData = try? JSONEncoder().encode(projects) {
					watchContext[WatchDataTypeSyncKey.projects] = projectsData
				}
			}
			group.leave()
		}

		group.notify(queue: .main) {
			do {
				try self.watchConnectivitySession.updateApplicationContext(watchContext)
			} catch let error {
				print(error.localizedDescription)
			}
		}

	}

	func configureAuthNotifications() {
		[AuthService.loginNotificationName, AuthService.logoutNotificationName].forEach { name in
			notificationCenter.addObserver(self,
										   selector: #selector(loginStatusChanged),
										   name: name,
										   object: nil)
		}
		
	}

	@objc func loginStatusChanged() {
		updateWatchData()
	}

}
