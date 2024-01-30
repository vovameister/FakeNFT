//
//  CollectionPresenter.swift
//  FakeNFT
//
//  Created by Artem Dubovitsky on 28.01.2024.
//
import Foundation

protocol CollectionPresenterProtocol: AnyObject {
    var nfts: [NFTs] { get }
    var collectionView: CollectionViewControllerProtocol? { get set }
    func loadAuthor()
    func getNtfs()
}

final class CollectionPresenter: CollectionPresenterProtocol {
    // MARK: - Properties
    var collectionNft: NFTCollection?
    var nfts: [NFTs] = []
    weak var collectionView: CollectionViewControllerProtocol?
    private let catalogService: CatalogServiceProtocol
    // MARK: - Initializers
    init(collectionNft: NFTCollection?, catalogService: CatalogServiceProtocol) {
        self.collectionNft = collectionNft
        self.catalogService = catalogService
    }
    // MARK: - Public Methods
    func loadAuthor() {
        guard let id = collectionNft?.author else { return }
        collectionView?.showLoadIndicator()
        catalogService.getAuthorNftCollection(id: id) { [weak self] result in
            guard let self = self else { return }
            self.prepare(authorName: result.name)
            self.collectionView?.hideLoadIndicator()
        }
    }
    
    func getNtfs() {
        guard let collectionNft, !collectionNft.nfts.isEmpty else { return }
        collectionNft.nfts.forEach {
            collectionView?.showLoadIndicator()
            catalogService.getNFTs(id: $0, completion: { [weak self] result in
                guard let self = self else { return }
                switch result {
                case .success(let nft):
                    self.nfts.append(nft)
                    self.collectionView?.reloadNftCollectionView()
                case .failure(let error):
                    print(error)
                    // TODO: - обработать ошибку алертом (Part-3)
                }
                self.collectionView?.hideLoadIndicator()
            })
        }
    }
    // MARK: - Private Methods
    private func prepare(authorName: String) {
        guard let collection = collectionNft else { return }
        let collectionViewData = CollectionViewData(
            coverImage: collection.cover,
            collectionName: collection.name,
            authorName: authorName,
            description: collection.description
        )
        collectionView?.collectionViewData(data: collectionViewData)
    }
}
