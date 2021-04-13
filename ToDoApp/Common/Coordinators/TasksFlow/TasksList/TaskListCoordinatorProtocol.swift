//
//  TaskListCoordinatorProtocol.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 04.04.2021.
//

import Foundation

protocol TasksListCoordinator: Coordinator {
	func showEditTask(_ task: Task)
	func showAddTask()
	func childDidFinish(_ child: Coordinator?)

	func changeTasksOrder(in orderStorage: TasksOrderStorage)
	func tasksOrderChanged()
}
