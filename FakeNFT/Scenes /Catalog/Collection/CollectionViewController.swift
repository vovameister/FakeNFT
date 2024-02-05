//
//  CollectionViewController.swift
//  FakeNFT
//
//  Created by Artem Dubovitsky on 28.01.2024.
//
import Kingfisher
import UIKit
import SafariServices

protocol CollectionViewControllerProtocol: AnyObject, AlertCatalogView {
    func collectionViewData(data: CollectionViewData)
    func reloadNftCollectionView()
    func showLoadIndicator()
    func hideLoadIndicator()
}

final class CollectionViewController: UIViewController {
    // MARK: - Properties
    var presenter: CollectionPresenterProtocol
    // MARK: - UI-Elements
    private lazy var backButton: UIBarButtonItem = {
        let button = UIBarButtonItem(
            image: UIImage(systemName: "chevron.backward"),
            style: .plain,
            target: self,
            action: #selector(backButtonTapped))
        button.tintColor = .black
        return button
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .clear
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isScrollEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let descriptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.backgroundColor = .clear
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var collectionCoverImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    private lazy var collectionName: UILabel = {
        let label = UILabel()
        label.font = .headline3
        label.textColor = .textPrimary
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var collectionAuthor: UILabel = {
        let label = UILabel()
        label.text = "Автор коллекции:"
        label.font = .caption2
        label.textColor = .textPrimary
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var collectionAuthorLink: UILabel = {
        let label = UILabel()
        label.font = .caption1
        label.textColor = .yaBlueUniversal
        label.numberOfLines = 0
        let gesture = UITapGestureRecognizer(
            target: self,
            action: #selector(collectionAuthorLinkTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(gesture)
        return label
    }()
    
    private lazy var collectionDescription: UILabel = {
        let label = UILabel()
        label.font = .caption2
        label.textColor = .textPrimary
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    private let nftCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.allowsMultipleSelection = false
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    // MARK: - Initializers
    init(presenter: CollectionPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.collectionView = self
        presenter.loadCollectionData()
        presenter.getNtfs()
        setupCollectionViewController()
    }
    // MARK: - Setup View
    private func setupCollectionViewController() {
        view.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = backButton
        addSubviews()
        setupCollectionView()
        setupCollectionViewControllerConstrains()
    }
    
    private func addSubviews() {
        view.addSubview(scrollView)
        
        [collectionCoverImage,
         descriptionStackView,
         nftCollectionView
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview($0)
        }
        
        [collectionName,
         collectionAuthor,
         collectionAuthorLink,
         collectionDescription
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            descriptionStackView.addSubview($0)
        }
    }
    
    private func setupCollectionView() {
        nftCollectionView.dataSource = self
        nftCollectionView.delegate = self
        nftCollectionView.register(CollectionViewCell.self)
    }
    
    private func setupCollectionViewControllerConstrains() {
        var navigationBarHeight: CGFloat {
            (navigationController?.view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
        }
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: -navigationBarHeight),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            collectionCoverImage.topAnchor.constraint(equalTo: scrollView.topAnchor),
            collectionCoverImage.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionCoverImage.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionCoverImage.heightAnchor.constraint(equalToConstant: 310),
            
            descriptionStackView.topAnchor.constraint(equalTo: collectionCoverImage.bottomAnchor, constant: 16),
            descriptionStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            descriptionStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            collectionName.topAnchor.constraint(equalTo: descriptionStackView.topAnchor),
            collectionName.leadingAnchor.constraint(equalTo: descriptionStackView.leadingAnchor, constant: 16),
            collectionName.trailingAnchor.constraint(equalTo: descriptionStackView.trailingAnchor, constant: -16),
            
            collectionAuthor.topAnchor.constraint(equalTo: collectionName.bottomAnchor, constant: 8),
            collectionAuthor.leadingAnchor.constraint(equalTo: collectionName.leadingAnchor),
            
            collectionAuthorLink.leadingAnchor.constraint(equalTo: collectionAuthor.trailingAnchor, constant: 4),
            collectionAuthorLink.centerYAnchor.constraint(equalTo: collectionAuthor.centerYAnchor),
            
            collectionDescription.topAnchor.constraint(equalTo: collectionAuthor.bottomAnchor, constant: 5),
            collectionDescription.leadingAnchor.constraint(equalTo: collectionName.leadingAnchor),
            collectionDescription.trailingAnchor.constraint(equalTo: collectionName.trailingAnchor),
            collectionDescription.bottomAnchor.constraint(equalTo: descriptionStackView.bottomAnchor),
            
            nftCollectionView.topAnchor.constraint(equalTo: descriptionStackView.bottomAnchor, constant: 24),
            nftCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nftCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nftCollectionView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        ])
    }
    // MARK: - Actions
    @objc
    private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func collectionAuthorLinkTapped() {
        guard let url = URL(string: presenter.authorURL ?? "") else { return }
        let safaryViewController = SFSafariViewController(url: url)
        navigationController?.present(safaryViewController, animated: true)
    }
}
// MARK: - UICollectionViewDataSource
extension CollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return presenter.nfts.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CollectionViewCell = collectionView.dequeueReusableCell(indexPath: indexPath)
        let cellModel = presenter.getModel(for: indexPath)
        cell.configCollectionCell(nftModel: cellModel)
        cell.indexPath = indexPath
        cell.delegate = self
        return cell
    }
}
// MARK: - UICollectionViewDelegateFlowLayout
extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width - 18) / 3, height: 192)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
// MARK: - CollectionViewControllerProtocol
extension CollectionViewController: CollectionViewControllerProtocol {
    func collectionViewData(data: CollectionViewData) {
        DispatchQueue.main.async {
            self.collectionCoverImage.kf.setImage(with: URL(string: data.coverImage))
            self.collectionName.text = data.collectionName
            self.collectionAuthorLink.text = data.authorName
            self.collectionDescription.text = data.description
        }
    }
    
    func reloadNftCollectionView() {
        nftCollectionView.reloadData()
    }
    
    func showLoadIndicator() {
        UIBlockingProgressHUD.show()
    }
    
    func hideLoadIndicator() {
        UIBlockingProgressHUD.dismiss()
    }
}
// MARK: - CollectionViewCellDelegate
extension CollectionViewController: CollectionViewCellDelegate {
    func likeButtonDidChange(for indexPath: IndexPath, isLiked: Bool) {
        presenter.changeLike(for: indexPath, isLiked: isLiked)
    }
    
    func cartButtonDidChange(for indexPath: IndexPath) {
        presenter.changeOrder(for: indexPath)
    }
}
