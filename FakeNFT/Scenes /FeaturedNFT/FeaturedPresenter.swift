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
final class FeaturedPresenter {
    private let service = MyNFTService.shared

    func isLikeTap(nftName: String) {
        if let id = service.mapNFTId(for: nftName) {
            let value = service.containsInt(value: id)
            if !value {
                service.likedNFTsid.append(id)
            } else {
                if let index = service.likedNFTsid.firstIndex(of: id) {
                    service.likedNFTsid.remove(at: index)
                }
            }
            service.updateLikedNFT()
        } else {
            print("ID not found for the given NFT name: \(nftName)")
        }
    }
}
