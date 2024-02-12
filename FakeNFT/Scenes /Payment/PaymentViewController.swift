//
//  PaymentViewController.swift
//  FakeNFT
//
//  Created by Кира on 29.01.2024.
//

import UIKit

protocol PaymentView: AnyObject, ErrorView, LoadingView {
    func setCollectionView(currencies: [CurrencyModel])
    func showPaymentResultView()
    func cleanCart()
}

protocol PaymentViewControllerDelegate: AnyObject {
    func didSelectCurrency(with currencyID: String)
    func didDeselectCurrency()
}

protocol PaymentSuccessDelegate: AnyObject {
    func cleanCart()
}

final class PaymentViewController: UIViewController {
    
    init(presenter: PaymentViewPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let presenter: PaymentViewPresenterProtocol
    private var selectedCurrencyID: String = ""
    let paymentViewCell = PaymentViewCell()
    weak var delegate: PaymentSuccessDelegate?
    
    private lazy var grayBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ypLightGray
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var payButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("Payment.payButton", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.layer.cornerRadius = 16
        button.setTitleColor(UIColor.ypWhite, for: .normal)
        button.backgroundColor = UIColor.ypBlack
        button.addTarget(self, action: #selector(payButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "backButton"), for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor.ypBlack
        label.text = NSLocalizedString("Payment.title", comment: "")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var agreementLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.ypBlack
        label.text = NSLocalizedString("Payment.agreement", comment: "")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var linkLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.ypBlue
        label.text = NSLocalizedString("Payment.linkAgreement", comment: "")
        label.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(linkLabelButtonTapped))
        label.addGestureRecognizer(tapGesture)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var paymentCollectionView = PaymentCollectionView()
    internal lazy var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        presenter.viewDidLoad()
        paymentCollectionView.paymentDelegate = self
    }
    
    private func prepareView() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.ypWhite
        view.addSubview(titleLabel)
        view.addSubview(paymentCollectionView)
        view.addSubview(backButton)
        view.addSubview(grayBackground)
        view.addSubview(activityIndicator)
        grayBackground.addSubview(agreementLabel)
        grayBackground.addSubview(linkLabel)
        grayBackground.addSubview(payButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 11),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 9),
            backButton.heightAnchor.constraint(equalToConstant: 24),
            backButton.widthAnchor.constraint(equalToConstant: 24),
            
            grayBackground.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            grayBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            grayBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            grayBackground.heightAnchor.constraint(equalToConstant: 152),
            
            payButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 12),
            payButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -12),
            payButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            payButton.heightAnchor.constraint(equalToConstant: 60),
            
            agreementLabel.topAnchor.constraint(equalTo: grayBackground.topAnchor, constant: 16),
            agreementLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            linkLabel.topAnchor.constraint(equalTo: agreementLabel.bottomAnchor),
            linkLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            
            paymentCollectionView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            paymentCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            paymentCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            paymentCollectionView.bottomAnchor.constraint(equalTo: grayBackground.topAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func payButtonTapped() {
        presenter.didTapPayButton(currencyID: selectedCurrencyID)
    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc private func linkLabelButtonTapped() {
        guard let url = URL(string: "https://yandex.ru/legal/practicum_termsofuse/") else { return }
        let webView = WebViewViewController(link: url)
        webView.modalPresentationStyle = .fullScreen
        present(webView, animated: true)
    }
    
    func cleanCart() {
        delegate?.cleanCart()
    }
}

extension PaymentViewController: PaymentView {
    func setCollectionView(currencies: [CurrencyModel]) {
        paymentCollectionView.configureCollectionView(currs: currencies)
    }
    
    func showPaymentResultView(){
        let paymentResult = PaymentResultViewController()
        paymentResult.modalPresentationStyle = .fullScreen
        present(paymentResult, animated: true)
    }
}

extension PaymentViewController: PaymentViewControllerDelegate {
    func didSelectCurrency(with currencyID: String) {
        payButton.isEnabled = true
        selectedCurrencyID = currencyID
    }
    
    func didDeselectCurrency() {
        payButton.isEnabled = false
        selectedCurrencyID = ""
    }
}

