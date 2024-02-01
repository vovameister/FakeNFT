//
//  UserCollectionAssembly.swift
//  FakeNFT
//
//  Created by Ramilia on 30/01/24.
//

import UIKit

final class UserNftsAssembly {
    
    func build() -> UIViewController {
        let presenter = UserNftsPresenter()
        let viewController = UserNftsViewController(presenter: presenter)
        presenter.view = viewController
        viewController.modalPresentationStyle = .fullScreen
        return viewController
    }
}
