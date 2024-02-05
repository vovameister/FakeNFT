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
    var authorURL: String? { get }
    func loadCollectionData()
    func getNtfs()
    func getModel(for indexPath: IndexPath) -> NFTCellModel
    func changeLike(for indexPath: IndexPath, isLiked: Bool)
}

final class CollectionPresenter: CollectionPresenterProtocol {
    // MARK: - Properties
    var collectionNft: NFTCollection?
    var nfts: [NFTs] = []
    var authorURL: String?
    var profile: ProfileResult?
    weak var collectionView: CollectionViewControllerProtocol?
    private let catalogService: CatalogServiceProtocol
    // MARK: - Initializers
    init(collectionNft: NFTCollection?, catalogService: CatalogServiceProtocol) {
        self.collectionNft = collectionNft
        self.catalogService = catalogService
    }
    // MARK: - Public Methods
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
    
    func loadCollectionData() {
        self.prepare()
        loadAuthor()
        getLikes()
        self.collectionView?.hideLoadIndicator()
    }
    
    func getModel(for indexPath: IndexPath) -> NFTCellModel {
        self.convertToCellModel(nft: nfts[indexPath.row])
    }
    
    func changeLike(for indexPath: IndexPath, isLiked: Bool) {
        collectionView?.showLoadIndicator()
        catalogService.putProfile(id: nfts[indexPath.row].id, completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                self.profile = profile
            case .failure(let error):
                print(error)
            }
            self.collectionView?.reloadNftCollectionView()
            self.collectionView?.hideLoadIndicator()
        })
    }
    // MARK: - Private Methods
    private func prepare() {
        guard let collection = collectionNft else { return }
        let collectionViewData = CollectionViewData(
            coverImage: collection.cover,
            collectionName: collection.name.firstUppercased,
            authorName: convertAuthorName(),
            description: collection.description.firstUppercased
        )
        collectionView?.collectionViewData(data: collectionViewData)
    }
    
    private func loadAuthor() {
        // моковый сайт
        self.authorURL = RequestConstants.stubAuthorUrl
    }
    
    private func convertAuthorName() -> String {
        let name = collectionNft?.author
        let modifed = name?.replacingOccurrences(of: "_", with: " ")
        return modifed?.capitalized ?? ""
    }
    
    private func convertToCellModel(nft: NFTs) -> NFTCellModel {
        return NFTCellModel(
            id: nft.id,
            name: nft.name.components(separatedBy: " ").first ?? "",
            image: nft.images.first,
            rating: nft.rating,
            isLiked: catalogService.likeStatus(nft.id), 
            price: nft.price
        )
    }
    
    private func getLikes() {
        catalogService.getProfile(completion: { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let profile):
                self.profile = profile
            case .failure(let error):
                print(error)
            }
        })
    }
}
