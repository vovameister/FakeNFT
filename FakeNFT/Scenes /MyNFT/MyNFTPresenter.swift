//
//  MyNFTPresenter.swift
//  FakeNFT
//
//  Created by Владимир Клевцов on 27.1.24..
//

import Foundation
protocol MyNFTPresenterProtocol {
    func sortByPrice()
    func sortByRating()
    func sortByName()
    func isLikeTap(indexPath: IndexPath) -> Bool
    func isLike(indexPath: IndexPath) -> Bool
}

final class MyNFTPresenter: MyNFTPresenterProtocol {
    private let service = MyNFTService.shared

    weak var viewController: MyNFTViewController?
    init(viewController: MyNFTViewController) {
        self.viewController = viewController
    }

    func sortByRating() {
        service.sortByRating()
    }

    func sortByName() {
        service.sortByName()
    }

    func sortByPrice() {
        service.sortByPrice()
    }
    func isLikeTap(indexPath: IndexPath) -> Bool {
        viewController?.showLoader()
        let id = service.myNFTs[indexPath.row].id
        let value = service.contains(value: id)
        if !value {
            service.likedNFTsid.append(id)
        } else {
            if let index = service.likedNFTsid.firstIndex(of: id) {
                service.likedNFTsid.remove(at: index)

            }
        }
        service.putLikes(likes: service.likedNFTsid) { [weak self] result in
            guard let self = self else {
                return
            }
            service.updateLikedNFT()
            switch result {
            case .success:
                viewController?.hideLoader()
            case .failure(let error):
                print(error)
                viewController?.hideLoader()
            }
        }
        return value
    }
    func isLike(indexPath: IndexPath) -> Bool {
        let id = service.myNFTs[indexPath.row].id
        let value = service.contains(value: id)

        return value
    }
}
