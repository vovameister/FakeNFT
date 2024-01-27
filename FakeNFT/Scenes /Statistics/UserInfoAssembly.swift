//
//  UserInfoAssembly.swift
//  FakeNFT
//
//  Created by Ramilia on 26/01/24.
//

import UIKit

final class UserInfoAssembly {
    
    func build(with input: String) -> UIViewController {
        let presenter = UserInfoPresenter(
            userID: input
        )
        let viewController = UserInfoViewController(presenter: presenter)
        presenter.view = viewController
        viewController.modalPresentationStyle = .fullScreen
        return viewController
    }
}
