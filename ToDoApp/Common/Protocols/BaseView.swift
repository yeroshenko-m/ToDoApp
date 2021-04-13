//
//  BaseDisplayLogic.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 04.03.2021.
//

import UIKit

protocol BaseView: UIViewController {}

extension BaseView {

	func display<E: Error>(error: E,
						   message: String? = nil,
						   dismissButtonTitle: String? = nil,
						   dismissHandler: ((UIAlertAction) -> Void)? = nil) {
		UINotificationFeedbackGenerator().notificationOccurred(.error)
		let alertController = UIAlertController(title: error.localizedDescription,
												message: message,
												preferredStyle: .alert)
		let cancelAction = UIAlertAction(title: dismissButtonTitle ?? "OK",
										 style: .cancel,
										 handler: dismissHandler)
		alertController.addAction(cancelAction)
		present(alertController, animated: true, completion: nil)
	}
	
}
