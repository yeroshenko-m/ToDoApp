//
//  ColorsListViewController.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 26.01.2021.
//

import UIKit

// MARK: - Protocol

protocol SelectProjectColorView: BaseView {
	func display(colors: [TodoistColor.Color])
}

// MARK: - ViewController

final class SelectProjectColorViewController: UIViewController {

	// MARK: - IBOutlets

    @IBOutlet private weak var collectionView: UICollectionView!

	// MARK: - Consts

	private let collectionViewCellSideSize: CGFloat = 80.0
	private let collectionViewMinimumSpacing: CGFloat = 10.0
	private let collectionViewContentInset = UIEdgeInsets(top: 15, left: 10, bottom: 10, right: 10)

    // MARK: - Properties

	var onColorChangedAction: ((Int?) -> Void)?
	private var interactor: SelectProjectColorInteractor?
	var currentColorId = TodoistColor.defaultColor.id
	private var colors = [TodoistColor.Color]()

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
		configureCollectionView()
		fetchColors()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: - Config

	private func configureScene() {
		let view = self
		let presenter = SelectProjectColorPresenterImpl(view: view)
		let interactor = SelectProjectColorInteractorImpl(presenter: presenter)
		view.interactor = interactor
	}

    private func configureCollectionView() {
        collectionView.register(ColorCVCell.nib(),
                                forCellWithReuseIdentifier: ColorCVCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemGray5
        collectionView.contentInset = collectionViewContentInset
    }

    private func configureBarButtons() {
        let removeButton = UIBarButtonItem(title: R.string.localizable.addEditControllers_resetBarbuttonTitle(),
                                           style: .plain,
                                           target: self,
                                           action: #selector(removeButtonHandler))
        navigationItem.setRightBarButton(removeButton,
                                        animated: false)
    }

	// MARK: - Methods

	private func fetchColors() {
		interactor?.fetchColors()
	}
    
    // MARK: - Selectors

    @objc
	private func removeButtonHandler() {
		onColorChangedAction?(nil)
    }

}

// MARK: - ViewController+View

extension SelectProjectColorViewController: SelectProjectColorView {

	func display(colors: [TodoistColor.Color]) {
		self.colors = colors
		collectionView.reloadData()
	}

}

// MARK: - ViewController+CollectionViewDataSource&Delegate

extension SelectProjectColorViewController: UICollectionViewDataSource,
											UICollectionViewDelegate {

	func collectionView(_ collectionView: UICollectionView,
						numberOfItemsInSection section: Int) -> Int {
		colors.count
	}

	func collectionView(_ collectionView: UICollectionView,
						cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let model = ColorCellDisplayObject(color: colors[indexPath.row].value)
		let cell = collectionView.dequeueReusableItem(withModel: model, for: indexPath)
		if model.color == TodoistColor.getColorBy(id: currentColorId) {
			(cell as? ColorCVCell)?.checkmarkImageView.isHidden = false
		}
		return cell
	}

	func collectionView(_ collectionView: UICollectionView,
						didSelectItemAt indexPath: IndexPath) {
		UISelectionFeedbackGenerator().selectionChanged()
		onColorChangedAction?(colors[indexPath.row].id)
	}

}

extension SelectProjectColorViewController: UICollectionViewDelegateFlowLayout {

	func collectionView(_ collectionView: UICollectionView,
						layout collectionViewLayout: UICollectionViewLayout,
						sizeForItemAt indexPath: IndexPath) -> CGSize {
		CGSize(width: collectionViewCellSideSize,
			   height: collectionViewCellSideSize)
	}

	func collectionView(_ collectionView: UICollectionView,
						layout collectionViewLayout: UICollectionViewLayout,
						minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		collectionViewMinimumSpacing
	}

	func collectionView(_ collectionView: UICollectionView,
						layout collectionViewLayout: UICollectionViewLayout,
						minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		collectionViewMinimumSpacing
	}

}
