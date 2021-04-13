//
//  WKInterfaceTable+Extension.swift
//  ToDoWatchApp Extension
//
//  Created by Mykhailo Yeroshenko on 08.04.2021.
//

import WatchKit

extension WKInterfaceTable {

	func insertRows(at indexSet: IndexSet,
					ofType controller: RowControllerType) {
		insertRows(at: indexSet,
				   withRowType: controller.type)
	}

}
