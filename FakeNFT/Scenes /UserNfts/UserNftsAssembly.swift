//
//  UserCollectionAssembly.swift
//  FakeNFT
//
//  Created by Ramilia on 30/01/24.
//

import UIKit

final class UserNftsAssembly {
    
    private let networkClient = DefaultNetworkClient()
    
    private var userNftService: UserNftServiceProtocol {
        UserNftService(
            networkClient: networkClient
        )
    }
    
    private var likeService: LikesServiceProtocol {
        LikesService (
            networkClient: networkClient
        )
    }
    
    func build(with input: [String]) -> UIViewController {
        let presenter = UserNftsPresenter(
            nftsInput: input,
            nftService: userNftService,
            likeService: likeService
        )
        let viewController = UserNftsViewController(presenter: presenter)
        presenter.view = viewController
        viewController.modalPresentationStyle = .fullScreen
        return viewController
    }
}
