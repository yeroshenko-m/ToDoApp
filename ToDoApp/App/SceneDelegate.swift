//
//  SceneDelegate.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 19.01.2021.
//

import UIKit

class SceneDelegate: UIResponder,
					 UIWindowSceneDelegate {

    var window: UIWindow?

	var coordinator: AppCoordinator?
	private let authService = AuthService()

    func scene(_ scene: UIScene,
			   willConnectTo session: UISceneSession,
			   options connectionOptions: UIScene.ConnectionOptions) {
        guard
			let windowScene = (scene as? UIWindowScene)
		else { return }

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowScene = windowScene
		let authService = AuthService()
		let navigation = NavController()
		coordinator = AppCoordinatorImpl(appWindow: window,
										 navigation: navigation,
										 appAuthService: authService)
		coordinator?.start()
		window?.makeKeyAndVisible()
    }
	
	func sceneWillEnterForeground(_ scene: UIScene) {
		guard authService.isAuthorized else {
			coordinator?.showLoginFlow()
			return
		}
		return
	}

}
