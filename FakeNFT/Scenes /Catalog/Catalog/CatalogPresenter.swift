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
    func makeSortingModel() -> AlertModel
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
                self.catalogView?.hideLoadIndicator()
            case .failure(let error):
                let errorModel = makeErrorModel(error)
                self.catalogView?.hideLoadIndicator()
                catalogView?.openAlert(
                    title: errorModel.title,
                    message: errorModel.message,
                    alertStyle: .alert,
                    actionTitles: errorModel.actionTitles,
                    actionStyles: [.default, .default],
                    actions: [{ _ in }, { _ in
                        self.getNtfCollections()}]
                )
            }
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
    
    func makeSortingModel() -> AlertModel {
        let title: String = NSLocalizedString("Catalog.sorting", comment: "")
        let message: String? = nil
        let actionSortByName: String =  NSLocalizedString("Catalog.sortingByName", comment: "")
        let actionSortByCount: String =  NSLocalizedString("Catalog.sortingByCount", comment: "")
        let actionClose: String =  NSLocalizedString("Catalog.sortingClose", comment: "")
        return AlertModel(
            title: title,
            message: message,
            actionTitles: [actionSortByName,
                           actionSortByCount,
                           actionClose]
        )
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
    
    private func makeErrorModel(_ error: Error) -> AlertModel {
        let title: String = NSLocalizedString("Error.title", comment: "")
        let message: String
        switch error {
        case is NetworkClientError:
            message = NSLocalizedString("Error.network", comment: "")
        default:
            message = NSLocalizedString("Error.unknown", comment: "")
        }
        
        let actionText: String =  NSLocalizedString("Error.repeat", comment: "")
        let cancelText: String = NSLocalizedString("Error.cancel", comment: "")
        return AlertModel(
            title: title,
            message: message,
            actionTitles: [cancelText,
                           actionText]
        )
    }
}
