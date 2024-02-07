//
//  MyNFTHelper.swift
//  FakeNFT
//
//  Created by Владимир Клевцов on 26.1.24..
//

import Foundation

protocol MyNFTHelperProtocol {
    func updateTableView(indexPath: IndexPath) -> MyNFT
    func nuberOfCell() -> Int
    func showNoFavoriteLabel()
}

final class MyNFTHelper: MyNFTHelperProtocol {

    private weak var myNFTViewController: MyNFTViewController?
    private let service = MyNFTService.shared

    init(viewController: MyNFTViewController) {
        self.myNFTViewController = viewController
        updateMyNFTView()
    }

    func updateTableView(indexPath: IndexPath) -> MyNFT {
        return service.myNFTs[indexPath.row]
    }
    func nuberOfCell() -> Int {
        service.myNFTs.count
    }
    func showNoFavoriteLabel() {
        if service.myNFTs.count == 0 {
            myNFTViewController?.noNFTLabel.isHidden = false
        } else {
            myNFTViewController?.noNFTLabel.isHidden = true
        }
    }
    func updateMyNFTView() {
        service.loadNFT { result in
            switch result {
            case .success(let nft):
                self.showNoFavoriteLabel()
                self.myNFTViewController?.tableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
}
