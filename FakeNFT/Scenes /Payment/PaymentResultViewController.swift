//
//  PaymentResultViewController.swift
//  FakeNFT
//
//  Created by Кира on 02.02.2024.
//

import UIKit

enum PaymentResultState {
    case  failed(Error), success
}

final class PaymentResultViewController: UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.ypWhite
        prepareView()
    }
    
    private lazy var successImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "successPay")
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var successLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 22)
        label.textColor = UIColor.ypBlack
        label.text = NSLocalizedString("Payment.paySuccess", comment: "")
        label.numberOfLines = 0
        label.textAlignment = .center
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("Payment.backButton", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.layer.cornerRadius = 16
        button.setTitleColor(UIColor.ypWhite, for: .normal)
        button.backgroundColor = UIColor.ypBlack
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private func prepareView() {
        view.addSubview(successImage)
        view.addSubview(successLabel)
        view.addSubview(backButton)
        
        NSLayoutConstraint.activate([
            successImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            successImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            successImage.widthAnchor.constraint(equalToConstant: 278),
            successImage.heightAnchor.constraint(equalToConstant: 278),
            
            successLabel.topAnchor.constraint(equalTo: successImage.bottomAnchor, constant: 20),
            successLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 36),
            successLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -36),
            
            backButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            backButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            backButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
}
