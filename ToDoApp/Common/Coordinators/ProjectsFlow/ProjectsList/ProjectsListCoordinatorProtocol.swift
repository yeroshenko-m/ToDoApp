//
//  ProjectsListCoordinatorProtocol.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 04.04.2021.
//

import Foundation

protocol ProjectsListCoordinator: Coordinator {
	func showDetailsFor(project: Project)
	func showEdit(project: Project)
	func showAddProject()

	func showEdit(task: Task)
	func showAddTask(for project: Project)

	func changeProjectsOrder(in orderStorage: ProjectsOrderStorage)
	func projectOrderChanged()

	func changeTasksOrder(in orderStorage: TasksOrderStorage)
	func tasksOrderChanged()
}
