//
//  CartViewController.swift
//  FakeNFT
//
//  Created by Кира on 28.01.2024.
//

import UIKit

protocol CartView: AnyObject, LoadingView, ErrorView, CartSortView {
    func setTableView(nfts: [Nft])
    func setPrice(price: String)
    func isCartEmpty()
    func setCount(count: Int)
}

protocol CartViewControllerDelegate: AnyObject {
    func didTapCellDeleteButton(with id: String)
}

final class CartViewController: UIViewController {
    
    init(presenter: CartViewPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let presenter: CartViewPresenter
    
    private lazy var sortButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "sortButton"), for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var payButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("Cart.payButton", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.layer.cornerRadius = 16
        button.setTitleColor(UIColor.ypWhite, for: .normal)
        button.backgroundColor = UIColor.ypBlack
        button.addTarget(self, action: #selector(payButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var amountCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.ypBlack
        label.text = "0 NFT"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var amoutPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textColor = UIColor.ypGreen
        label.text = "0 ETH"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var grayBackground: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.ypLightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.text = NSLocalizedString("Cart.emptyCart", comment: "")
        label.isHidden = true
        label.textColor = UIColor.ypBlack
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var cartTableView = CartTableView()
    internal lazy var activityIndicator = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareView()
        presenter.view = self
        presenter.viewDidLoad()
        
        cartTableView.cartDelegate = self
        
    }
    
    private func prepareView() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.ypWhite
        view.addSubview(sortButton)
        view.addSubview(cartTableView)
        view.addSubview(placeholderLabel)
        view.addSubview(grayBackground)
        view.addSubview(activityIndicator)
        grayBackground.addSubview(amoutPriceLabel)
        grayBackground.addSubview(amountCountLabel)
        grayBackground.addSubview(payButton)
        
        NSLayoutConstraint.activate([
            sortButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 2),
            sortButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -9),
            sortButton.widthAnchor.constraint(equalToConstant: 41),
            sortButton.heightAnchor.constraint(equalToConstant: 41),
            
            cartTableView.topAnchor.constraint(equalTo: sortButton.bottomAnchor, constant: 20),
            cartTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            cartTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            cartTableView.bottomAnchor.constraint(equalTo: grayBackground.topAnchor),
            
            grayBackground.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            grayBackground.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            grayBackground.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            grayBackground.heightAnchor.constraint(equalToConstant: 76),
            
            amountCountLabel.leadingAnchor.constraint(equalTo: grayBackground.leadingAnchor, constant: 16),
            amountCountLabel.topAnchor.constraint(equalTo: grayBackground.topAnchor, constant: 16),
            
            amoutPriceLabel.leadingAnchor.constraint(equalTo: grayBackground.leadingAnchor, constant: 16),
            amoutPriceLabel.topAnchor.constraint(equalTo: amountCountLabel.bottomAnchor, constant: 2),
            
            payButton.topAnchor.constraint(equalTo: grayBackground.topAnchor, constant: 16),
            payButton.trailingAnchor.constraint(equalTo: grayBackground.trailingAnchor, constant: -16),
            payButton.bottomAnchor.constraint(equalTo: grayBackground.bottomAnchor, constant: -16),
            payButton.widthAnchor.constraint(equalToConstant: 240),
            payButton.heightAnchor.constraint(equalToConstant: 44),
            
            placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            placeholderLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func payButtonTapped() {
        let currencyService = PaymentService(networkClient: DefaultNetworkClient(), storage: CurrencyStorageImpl())
        let paymentPresenter = PaymentViewPresenter(service: currencyService)
        let paymentViewController = PaymentViewController(presenter: paymentPresenter)
        paymentPresenter.view = paymentViewController
        paymentViewController.modalPresentationStyle = .fullScreen
        present(paymentViewController, animated: true)
        
    }
    
    @objc private func sortButtonTapped() {
        presenter.sortNFTs()
    }
}

extension CartViewController: CartView {
    func setTableView(nfts: [Nft]) {
        cartTableView.configureTableView(nfts: nfts)
    }
    
    func setPrice(price: String) {
        amoutPriceLabel.text = "\(price) ETH"
    }
    
    func isCartEmpty() {
        grayBackground.isHidden = true
        sortButton.isHidden = true
        cartTableView.isHidden = true
        amoutPriceLabel.isHidden = true
        amountCountLabel.isHidden = true
        payButton.isHidden = true
        placeholderLabel.isHidden = false
        
    }
    
    func setCount(count: Int) {
        amountCountLabel.text = "\(count) NFT"
    }
}

extension CartViewController: CartViewControllerDelegate {
    func didTapCellDeleteButton(with id: String) {
        presenter.didTapCellDeleteButton(with: id)
    }
}
