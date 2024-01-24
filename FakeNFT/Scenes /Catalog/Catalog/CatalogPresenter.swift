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
}

final class CatalogPresenter: CatalogPresenterProtocol {
    // MARK: - Properties
    var collectionsNft: [NFTCollection] = []
    weak var catalogView: CatalogViewControllerProtocol?
    private var catalogService: CatalogServiceProtocol
    // MARK: - Initializers
    init(catalogService: CatalogServiceProtocol) {
        self.catalogService = catalogService
    }
    // MARK: - Public Methods
    func getNtfCollections() {
        catalogService.getNtfCollections() { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let collections):
                self.collectionsNft = collections
                self.catalogView?.reloadCatalogTableView()
            case .failure(let error):
                print(error)
                // TODO: - обработать ошибку алертом
            }
        }
    }
}
