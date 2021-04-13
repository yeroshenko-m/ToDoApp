//
//  ExtensionDelegate.swift
//  ToDoWatchApp Extension
//
//  Created by Mykhailo Yeroshenko on 05.04.2021.
//

import WatchKit
import WatchConnectivity

class ExtensionDelegate: NSObject, WKExtensionDelegate {

	private let watchConnectivitySession = WCSession.default
	private let notificationCenter = NotificationCenter.default
	private let storage = WatchStorageManager.shared

    func applicationDidFinishLaunching() {
        configureConnectivitySession()
    }

    func applicationDidBecomeActive() {}

    func applicationWillResignActive() {}

    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
        for task in backgroundTasks {
            // Use a switch statement to check the task type
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                // Be sure to complete the background task once you’re done.
                backgroundTask.setTaskCompletedWithSnapshot(false)
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                // Snapshot tasks have a unique completion call, make sure to set your expiration date
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                // Be sure to complete the connectivity task once you’re done.
                connectivityTask.setTaskCompletedWithSnapshot(false)
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                // Be sure to complete the URL session task once you’re done.
                urlSessionTask.setTaskCompletedWithSnapshot(false)
            case let relevantShortcutTask as WKRelevantShortcutRefreshBackgroundTask:
                // Be sure to complete the relevant-shortcut task once you're done.
                relevantShortcutTask.setTaskCompletedWithSnapshot(false)
            case let intentDidRunTask as WKIntentDidRunRefreshBackgroundTask:
                // Be sure to complete the intent-did-run task once you're done.
                intentDidRunTask.setTaskCompletedWithSnapshot(false)
            default:
                // make sure to complete unhandled task types
                task.setTaskCompletedWithSnapshot(false)
            }
        }
    }

	// MARK: - Config

	private func configureConnectivitySession() {
		if WCSession.isSupported() {
			watchConnectivitySession.delegate = self
			watchConnectivitySession.activate()
		}
	}
}

extension ExtensionDelegate: WCSessionDelegate {

	func session(_ session: WCSession,
				 activationDidCompleteWith activationState: WCSessionActivationState,
				 error: Error?) {
		guard error == nil else {
			print("WCSession activation failed with error: \(String(describing: error?.localizedDescription))")
			return
		}
		print("WCSession activated with state: \(session.activationState.rawValue)")
	}

	func session(_ session: WCSession,
				 didReceiveApplicationContext applicationContext: [String: Any]) {
		print(applicationContext)
		if let authString = applicationContext["login"] as? String {
			if authString == "LoggedIn" {
				storage.store(authState: "LoggedIn")
				notificationCenter.post(name: .UserLoggedIn, object: nil)
			} else {
				storage.store(authState: "LoggedOut")
				notificationCenter.post(name: .UserLoggedOut, object: nil)
			}
		}

		if let projectsData = applicationContext[WatchDataTypeSyncKey.projects] as? Data {
			storage.store(projectsData: projectsData)
			notificationCenter.post(name: .StorageDataDidChange, object: nil)
		}
		
		if let tasksData = applicationContext[WatchDataTypeSyncKey.tasks] as? Data {
			storage.store(tasksData: tasksData)
			notificationCenter.post(name: .StorageDataDidChange, object: nil)
		}

	}

}
