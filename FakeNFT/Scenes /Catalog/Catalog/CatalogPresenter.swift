//
//  CatalogPresenter.swift
//  FakeNFT
//
//  Created by Artem Dubovitsky on 22.01.2024.
//
import Foundation

protocol CatalogPresenterProtocol: AnyObject {
    var collectionsNft: [NFTCollection] { get }
    var catalogView: CatalogViewControllerProtocol? { get set }
    func getNtfCollections()
    func sortingByName()
    func sortingByNftCount()
    func getModel(for indexPath: IndexPath) -> CatalogCellModel
}

final class CatalogPresenter: CatalogPresenterProtocol {
    // MARK: - Properties
    var collectionsNft: [NFTCollection] = []
    weak var catalogView: CatalogViewControllerProtocol?
    private let catalogService: CatalogServiceProtocol
    private let sortingStorage: SortingStorageProtocol
    // MARK: - Initializers
    init(catalogService: CatalogServiceProtocol, sortingStorage: SortingStorageProtocol) {
        self.catalogService = catalogService
        self.sortingStorage = sortingStorage
    }
    // MARK: - Public Methods
    func getNtfCollections() {
        catalogView?.showLoadIndicator()
        catalogService.getNtfCollections { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let collections):
                self.collectionsNft = collections
                self.getSortingCollections()
                self.catalogView?.reloadCatalogTableView()
            case .failure(let error):
                print(error)
                // TODO: - обработать ошибку алертом (Part-3)
            }
            self.catalogView?.hideLoadIndicator()
        }
    }
    
    func getModel(for indexPath: IndexPath) -> CatalogCellModel {
        self.convertToCellModel(collection: collectionsNft[indexPath.row])
    }
    
    func sortingByName() {
        sortingStorage.saveSorting(.byCollectionName)
        collectionsNft = collectionsNft.sorted {
            $0.name < $1.name
        }
        catalogView?.reloadCatalogTableView()
    }
    
    func sortingByNftCount() {
        sortingStorage.saveSorting(.byNftCount)
        collectionsNft = collectionsNft.sorted {
            $0.nfts.count > $1.nfts.count
        }
        catalogView?.reloadCatalogTableView()
    }
    // MARK: - Private Methods
    private func getSortingCollections() {
        let sortingStorage = sortingStorage.getSorting()
        switch sortingStorage {
        case .byCollectionName:
            sortingByName()
        case .byNftCount:
            sortingByNftCount()
        default: break
        }
    }
    
    private func convertToCellModel(collection: NFTCollection) -> CatalogCellModel {
        return CatalogCellModel(
            name: collection.name,
            image: URL(string: collection.cover),
            count: collection.nfts.count)
    }
}
