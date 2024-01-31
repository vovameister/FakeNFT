//
//  UserCollectionsViewController.swift
//  FakeNFT
//
//  Created by Ramilia on 30/01/24.
//

import UIKit

// MARK: - Protocol
protocol UserCollectionViewProtocol: AnyObject, ErrorView, LoadingView {
    func displayUserCollection()
}

final class UserCollectionViewController: UIViewController {
    
    // MARK: - Properties
    var activityIndicator = UIActivityIndicatorView()
    private let presenter: UserCollectionPresenterProtocol
    
    //MARK: - UI elements
    private lazy var navigationBar: UINavigationBar = {
        let navBar = UINavigationBar()
        navBar.barTintColor = .systemBackground
        
        let navItem = UINavigationItem(title: "")
        navItem.leftBarButtonItem =  UIBarButtonItem(customView: backButton)
        navItem.title = NSLocalizedString("UserInfo.nftCollections", comment: "")
        navBar.setItems([navItem], animated: false)
        
        navBar.shadowImage = UIImage()
        navBar.setBackgroundImage(UIImage(), for: .default)
        
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
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .headline3
        label.textColor = .textColor
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    init(presenter: UserCollectionPresenterProtocol) {
        self.presenter = presenter
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
        presenter.viewDidLoad()
    }
    
    @objc
    private func didTapBackButton() {
        dismiss(animated: true)
    }
    
    //MARK: - Layout
    private func setupViews() {
        view.backgroundColor = .systemBackground
        view.addSubview(activityIndicator)
        view.addSubview(navigationBar)
    }
    
    private func setupConstraints() {
        activityIndicator.constraintCenters(to: view)
        NSLayoutConstraint.activate([
            navigationBar.heightAnchor.constraint(equalToConstant: 42),
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}

extension UserCollectionViewController: UserCollectionViewProtocol {
    func displayUserCollection() {
        //code
    }
}

