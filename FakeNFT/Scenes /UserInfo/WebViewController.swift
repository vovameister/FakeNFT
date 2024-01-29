//
//  WebViewController.swift
//  FakeNFT
//
//  Created by Ramilia on 29/01/24.
//

import UIKit
import WebKit

final class WebViewController: UIViewController {
    
    private let request: URLRequest
    
    //MARK: - UI elements
    
    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: view.safeAreaLayoutGuide.layoutFrame)
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    private lazy var navigationBar: UINavigationBar = {
        let navBar = UINavigationBar()
        navBar.barTintColor = .systemBackground
        
        let navItem = UINavigationItem(title: "")
        navItem.leftBarButtonItem =  UIBarButtonItem(customView: backButton)
        navBar.setItems([navItem], animated: false)
        
        navBar.translatesAutoresizingMaskIntoConstraints = false
        return navBar
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "back") ?? UIImage(), for: .normal)
        button.addTarget(self, action: #selector(didTapBackButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - Init
    init(request: URLRequest) {
        self.request = request
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupConstraints()
        webView.load(request)
    }
    
    @IBAction func didTapBackButton(_ sender: Any) {
        dismiss(animated: true)
    }
    
    //MARK: - Layout
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(navigationBar)
        view.addSubview(webView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            navigationBar.heightAnchor.constraint(equalToConstant: 42),
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            webView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            
        ])
    }
}
