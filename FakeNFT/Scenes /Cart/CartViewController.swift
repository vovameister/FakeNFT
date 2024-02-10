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
    func showDeleteWarning(show: Bool)
    func enablePayButton()
}

protocol CartViewControllerDelegate: AnyObject {
    func didTapCellDeleteButton(with id: String, with image: UIImage)
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
        button.isEnabled = false
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
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
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
    
    private lazy var blurView: UIVisualEffectView = {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        view.frame = UIScreen.main.accessibilityFrame
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var nftImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 12
        imageView.isHidden = true
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("Cart.delete", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.layer.cornerRadius = 12
        button.setTitleColor(UIColor.ypRed, for: .normal)
        button.backgroundColor = UIColor.ypBlack
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var returnButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("Cart.return", comment: ""), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        button.layer.cornerRadius = 12
        button.setTitleColor(UIColor.ypWhite, for: .normal)
        button.backgroundColor = UIColor.ypBlack
        button.addTarget(self, action: #selector(returnButtonTapped), for: .touchUpInside)
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var deleteAcceptLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.text = NSLocalizedString("Cart.deleteAccept", comment: "")
        label.isHidden = true
        label.textColor = UIColor.ypBlack
        label.numberOfLines = 0
        label.textAlignment = .center
        label.sizeToFit()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var cartTableView = CartTableView()
    lazy var activityIndicator = UIActivityIndicatorView()
    
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
        view.addSubview(blurView)
        view.addSubview(nftImageView)
        view.addSubview(deleteButton)
        view.addSubview(returnButton)
        view.addSubview(deleteAcceptLabel)
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
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            nftImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 244),
            nftImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nftImageView.heightAnchor.constraint(equalToConstant: 108),
            nftImageView.widthAnchor.constraint(equalToConstant: 108),
            
            deleteAcceptLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            deleteAcceptLabel.topAnchor.constraint(equalTo: nftImageView.bottomAnchor, constant: 12),
            
            deleteButton.topAnchor.constraint(equalTo: deleteAcceptLabel.bottomAnchor, constant: 20),
            deleteButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 56),
            deleteButton.heightAnchor.constraint(equalToConstant: 44),
            deleteButton.widthAnchor.constraint(equalToConstant: 127),
            
            returnButton.topAnchor.constraint(equalTo: deleteAcceptLabel.bottomAnchor, constant: 20),
            returnButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -56),
            returnButton.heightAnchor.constraint(equalToConstant: 44),
            returnButton.widthAnchor.constraint(equalToConstant: 127)
        ])
    }
    
    @objc private func payButtonTapped() {
        let currencyService = PaymentService(networkClient: DefaultNetworkClient(), storage: CurrencyStorageImpl())
        let paymentPresenter = PaymentViewPresenter(service: currencyService)
        let paymentViewController = PaymentViewController(presenter: paymentPresenter)
        paymentPresenter.view = paymentViewController
        paymentViewController.modalPresentationStyle = .fullScreen
        paymentViewController.delegate = self
        present(paymentViewController, animated: true)
        
    }
    
    @objc private func deleteButtonTapped() {
        presenter.deleteButtonTapped()
    }
    
    @objc private func returnButtonTapped() {
        presenter.returnButtonTapped()
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
    
    func showDeleteWarning(show: Bool) {
        blurView.isHidden = !show
        nftImageView.isHidden = !show
        deleteButton.isHidden = !show
        returnButton.isHidden = !show
        deleteAcceptLabel.isHidden = !show
        self.navigationController?.isNavigationBarHidden = !show
        self.navigationController?.isToolbarHidden = !show
    }
    
    func enablePayButton() {
        payButton.isEnabled = true
    }
}

extension CartViewController: CartViewControllerDelegate {
    func didTapCellDeleteButton(with id: String, with image: UIImage) {
        presenter.didTapCellDeleteButton(with: id)
        nftImageView.image = image
    }
}

extension CartViewController: PaymentSuccessDelegate {
    func cleanCart() {
        presenter.cleanCart()
    }
}
