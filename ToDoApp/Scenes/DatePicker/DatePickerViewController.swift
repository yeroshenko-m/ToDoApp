//
//  DatePickerViewController.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 09.02.2021.
//

import UIKit

// MARK: - Protocol

protocol DatePickerView: BaseView {
	func displayDatePickerSuccess()
	func displayDatePickerFailure()
}

// MARK: - ViewController

final class DatePickerViewController: UIViewController {
    
    // MARK: - IBOutlets

    @IBOutlet private weak var datePicker: UIDatePicker!
    
	// MARK: - Properties

	var onDateChangedAction: ((Date?) -> Void)?
	private var interactor: DatePickerInteractor?
	var currentDate: Date?

	// MARK: - Init

	override init(nibName nibNameOrNil: String?,
				  bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil,
				   bundle: nibBundleOrNil)
		configureScene()
	}

	required init?(coder: NSCoder) {
		super.init(coder: coder)
		configureScene()
	}

    // MARK: - VC lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureBarButtons()
        configureDatePicker()
    }
    
    // MARK: - Config

	private func configureScene() {
		let view = self
		let presenter = DatePickerPresenterImpl(view: view)
		let interactor = DatePickerInteractorImpl(presenter: presenter)
		view.interactor = interactor
	}

    private func configureDatePicker() {
		datePicker.tintColor = R.color.iconsTintColor()
        if let selectedDate = currentDate {
            datePicker.date = selectedDate
        }
	}

	private func configureBarButtons() {
		let resetButton = UIBarButtonItem(barButtonSystemItem: .cancel,
										  target: self,
										  action: #selector(removeButtonHandler))

		let saveButton = UIBarButtonItem(barButtonSystemItem: .save,
										 target: self,
										 action: #selector(saveButtonHandler))

		navigationItem.rightBarButtonItems = [resetButton, saveButton]
	}

	// MARK: - IBActions

	@IBAction private func datePicker(_ sender: UIDatePicker) {
		interactor?.checkDateValidity(sender.date)
	}

	// MARK: - Selectors

    @objc
	private func removeButtonHandler() {
		onDateChangedAction?(nil)
    }
    
	@objc
	private func saveButtonHandler() {
		onDateChangedAction?(currentDate ?? datePicker.date)
	}
	
}

// MARK: - ViewController+View

extension DatePickerViewController: DatePickerView {

	func displayDatePickerSuccess() {
		currentDate = datePicker.date
	}

	func displayDatePickerFailure() {
		datePicker.date = Date()
	}

}
