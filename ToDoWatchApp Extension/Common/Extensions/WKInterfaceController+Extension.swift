//
//  WKInterfaceController+Extension.swift
//  ToDoWatchApp Extension
//
//  Created by Mykhailo Yeroshenko on 08.04.2021.
//

import WatchKit
import UIKit

extension WKInterfaceController {

	static var nameOfController: String {
		String(describing: Self.self)
	}

	func pushController(_ controller: InterfaceController, context: Any?) {
		pushController(withName: controller.name, context: context)
	}

}
