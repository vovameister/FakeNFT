//
//  FeaturedHelper.swift
//  FakeNFT
//
//  Created by Владимир Клевцов on 27.1.24..
//

import Foundation
protocol FeaturedHelperProtocol {
    func updateTableView(indexPath: IndexPath) -> MyNFT
    func nuberOfCell() -> Int
    func showNoFavoriteLabel()
}

final class FeaturedHelper: FeaturedHelperProtocol {

    private let viewController: FeaturedNFTViewController?
    private let service = MyNFTService.shared

    init(viewController: FeaturedNFTViewController) {
        self.viewController = viewController
    }

    func updateTableView(indexPath: IndexPath) -> MyNFT {
        return service.likedNFT[indexPath.row]
    }
    func nuberOfCell() -> Int {
        service.likedNFT.count
    }
    func showNoFavoriteLabel() {
        if service.likedNFTsid == [] {
            viewController?.noFavoriteLabel.isHidden = false
        } else {
            viewController?.noFavoriteLabel.isHidden = true
        }
    }
}
