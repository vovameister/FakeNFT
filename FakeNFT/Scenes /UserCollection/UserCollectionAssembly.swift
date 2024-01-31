//
//  UserCollectionAssembly.swift
//  FakeNFT
//
//  Created by Ramilia on 30/01/24.
//

import UIKit

final class UserCollectionAssembly {
    
    func build() -> UIViewController {
        let presenter = UserCollectionPresenter()
        let viewController = UserCollectionViewController(presenter: presenter)
        presenter.view = viewController
        viewController.modalPresentationStyle = .fullScreen
        return viewController
    }
}
