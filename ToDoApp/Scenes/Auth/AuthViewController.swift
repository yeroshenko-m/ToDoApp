//
//  ViewController.swift
//  ToDoApp
//
//  Created by Mykhailo Yeroshenko on 19.01.2021.
//

import UIKit
import WebKit

// MARK: - Protocol

protocol AuthView: BaseView {
	func displayAuthPage(url: URL)
	func displayAuthSuccess()
}

// MARK: - ViewController

final class AuthViewController: BaseViewController {

    // MARK: - IBOutlets

	@IBOutlet weak var webView: WKWebView!
    
    // MARK: - Properties

	private var interactor: AuthInteractor?
	var onAuthSuccess: (() -> Void)?

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
        configureWebView()
		configureNavigationItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activityIndicator.startAnimating()
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		interactor?.loadAuthURL()
	}
    
    // MARK: - Config

	private func configureScene() {
		let view = self
		let presenter = AuthPresenterImpl(view: view)
		let interactor = AuthInteractorImpl(authService: AuthService(), presenter: presenter)
		view.interactor = interactor
	}

    private func configureWebView() {
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.allowsBackForwardNavigationGestures = true
        webView.backgroundColor = .clear
    }
    
    private func configureNavigationItem() {
		navigationItem.title = R.string.localizable.authorizationScreen_title()
        let refreshButton = UIBarButtonItem(barButtonSystemItem: .refresh,
                                            target: self,
                                            action: #selector(refreshBarButtonPressed))
        navigationItem.setRightBarButton(refreshButton,
                                         animated: false)
    }
    
    // MARK: - Selectors

    @objc
	private func refreshBarButtonPressed() {
		UISelectionFeedbackGenerator().selectionChanged()
		interactor?.loadAuthURL()
	}
    
}

// MARK: - ViewController+View

extension AuthViewController: AuthView {

	func displayAuthPage(url: URL) {
		webView?.load(URLRequest(url: url))
	}

	func displayAuthSuccess() {
		UISelectionFeedbackGenerator().selectionChanged()
		interactor?.clearWebCache()
		onAuthSuccess?()
	}

}

// MARK: - ViewController+WebViewDelegate

extension AuthViewController: WKUIDelegate,
							  WKNavigationDelegate {

	func webView(_ webView: WKWebView,
				 decidePolicyFor navigationAction: WKNavigationAction,
				 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
		guard
			let url = navigationAction.request.url
		else { return }
		interactor?.fetchToken(url: url)
		decisionHandler(.allow)
	}

	func webView(_ webView: WKWebView,
				 didCommit navigation: WKNavigation!) {
		activityIndicator.startAnimating()
	}

	func webView(_ webView: WKWebView,
				 didFail navigation: WKNavigation!,
				 withError error: Error) {
		activityIndicator.stopAnimating()
	}

	func webView(_ webView: WKWebView,
				 didFinish navigation: WKNavigation!) {
		activityIndicator.stopAnimating()
	}

	func webView(_ webView: WKWebView,
				 createWebViewWith configuration: WKWebViewConfiguration,
				 for navigationAction: WKNavigationAction,
				 windowFeatures: WKWindowFeatures) -> WKWebView? {
		configuration.websiteDataStore = .nonPersistent()
		return WKWebView(frame: webView.frame, configuration: configuration)
	}

}
