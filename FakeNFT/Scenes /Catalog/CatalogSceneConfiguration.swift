//
//  CatalogSceneConfiguration.swift
//  FakeNFT
//
//  Created by Artem Dubovitsky on 30.01.2024.
//
import UIKit

class CatalogSceneConfiguration {
    let catalogViewController: UIViewController

    init() {
        let networkClient = DefaultNetworkClient()
        let catalogStorage = CatalogStorage()
        let catalogService = CatalogService(
            networkClient: networkClient,
            catalogStorage: catalogStorage)
        let sortingStorage = SortingStorage()
        let catalogPresenter = CatalogPresenter(
            catalogService: catalogService,
            sortingStorage: sortingStorage)
        catalogViewController = CatalogViewController(presenter: catalogPresenter)
    }

    func assemblyCollection(_ collection: NFTCollection) -> UIViewController {
        let networkClient = DefaultNetworkClient()
        let catalogStorage = CatalogStorage()
        let catalogService = CatalogService(
            networkClient: networkClient,
            catalogStorage: catalogStorage)
        let presenter = CollectionPresenter(
            collectionNft: collection,
            catalogService: catalogService)
        let viewCintroller = CollectionViewController(presenter: presenter)
        viewCintroller.hidesBottomBarWhenPushed = true
        return viewCintroller
    }
}
