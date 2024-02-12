//
//  FeaturedPresenter.swift
//  FakeNFT
//
//  Created by Владимир Клевцов on 27.1.24..
//

import Foundation
protocol FeaturedPresenterProtocol {
    func isLikeTap(nftName: String)
}
final class FeaturedPresenter: FeaturedPresenterProtocol {
    private let service = MyNFTService.shared

    weak var viewController: FeaturedNFTViewController?

    init(viewController: FeaturedNFTViewController) {
        self.viewController = viewController
    }
    func isLikeTap(nftName: String) {
        viewController?.showLoader()
        if let id = service.mapNFTId(for: nftName) {
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
                switch result {
                case .success:
                    service.updateLikedNFT()
                    viewController?.hideLoader()
                    self.viewController?.collectionView.reloadData()
                    self.viewController?.reloadImage()
                case .failure(let error):
                    print(error)
                    viewController?.hideLoader()
                }
            }
        } else {
            print("ID not found for the given NFT name: \(nftName)")
        }
    }
}
