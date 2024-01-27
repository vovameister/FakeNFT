//
//  UserInfoViewController.swift
//  FakeNFT
//
//  Created by Ramilia on 26/01/24.
//

import UIKit

// MARK: - Protocol
protocol UserInfoViewProtocol: AnyObject, ErrorView, LoadingView {
    func displayUserInfo()
}

final class UserInfoViewController: UIViewController {
   
    // MARK: - Properties
    var activityIndicator = UIActivityIndicatorView()
    private let presenter: UserInfoPresenterProtocol?
    
    // MARK: - Init
    init(presenter: UserInfoPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Functions
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
}

extension UserInfoViewController: UserInfoViewProtocol {
    func displayUserInfo() {
      //code
    }
}
