//
//  CollectionViewController.swift
//  FakeNFT
//
//  Created by Artem Dubovitsky on 28.01.2024.
//
import UIKit

final class CollectionViewController: UIViewController {
    // MARK: - UI-Elements
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
        imageView.image = UIImage(named: "CoverCollection") // для настройки, удалить
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 12
        return imageView
    }()
    
    private lazy var collectionName: UILabel = {
        let label = UILabel()
        label.text = "Test" // для настройки, удалить
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
        label.text = "John Doe" // для настройки, удалить
        label.font = .caption1
        label.textColor = .yaBlueUniversal
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var collectionDescription: UILabel = {
        let label = UILabel()
        label.text = "Персиковый — как облака над закатным солнцем в океане. В этой коллекции совмещены трогательная нежность и живая игривость сказочных зефирных зверей." // для настройки, удалить
        label.font = .caption2
        label.textColor = .textPrimary
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    private lazy var nftCollectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionViewController()
    }
    // MARK: - Setup View
    private func setupCollectionViewController() {
        view.backgroundColor = .systemBackground
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

    }
    
    private func setupCollectionViewControllerConstrains() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
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
            nftCollectionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
}
