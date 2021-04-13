//
//  TaskSectionsMapper.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 18.03.2021.
//

import Foundation

final class TasksSectionsMapper {

	/// Returns an array of objects TaskListSection,
	/// where 'name' property displays name of project,
	/// and 'tasks' property is an array of tasks, which have right sorting conditions
	static func mapToSectionsByProject(tasks: [Task]) -> [TasksListSection] {
		var sectionNames = tasks.map { $0.projectName }

		sectionNames.removeDuplicates()

		var sortedTasks = Array(repeating: [Task](), count: sectionNames.count)
		for (index, sectionName) in sectionNames.enumerated() {
			for task in tasks where task.projectName == sectionName {
				sortedTasks[index].append(task)
			}
		}

		var result = [TasksListSection]()
		for (index, sectionName) in sectionNames.enumerated() {
			result.append(.init(name: sectionName,
								tasks: sortedTasks[index]))
		}

		return result.sorted(by: { $0.name < $1.name })
	}

	/// Returns an array of objects TaskListSection for 1 week forward,
	/// where 'name' property displays date, and 'tasks' property is an array of tasks,
	/// which have appropriate date
	static func mapToSectionsByDate(tasks: [Task]) -> [TasksListSection] {
		let formatter = DateFormatter()
		let daysOfWeek = Date().daysOfWeek()

		var taskArrays = [[Task]]()

		for day in daysOfWeek {
			var tasksOfDay = [Task]()
			for task in tasks {
				guard let taskDue = task.due,
					  !taskDue.isEmpty
				else { continue }
				let dayString = formatter.shortRFC3339StringFrom(date: day)
				if isOnSameDay(taskDayString: taskDue,
							   currentDateString: dayString) {
					tasksOfDay.append(task)
				}
			}
			taskArrays.append(tasksOfDay)
		}

		var result = [TasksListSection]()
		for (index, day) in daysOfWeek.enumerated() {
			let dayString = formatter.stringRFC3339FromDate(day)
			result.append(.init(name: dayString,
								tasks: taskArrays[index]))
		}

		return result
	}

	private static func isOnSameDay(taskDayString firstString: String,
									currentDateString secondString: String) -> Bool {
		let formatter = DateFormatter()
		guard let date = formatter.dateFromRFC3339String(firstString)
		else { return false }
		let shortFirstString = formatter.shortRFC3339StringFrom(date: date)
		return shortFirstString == secondString
	}

}
