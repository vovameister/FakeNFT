//
//  EditProfimePresenter.swift
//  FakeNFT
//
//  Created by Владимир Клевцов on 16.1.24..
//

import Foundation
protocol EditProfilePresenterProtocol {
    func setNewAvata(url: String)
    func profileChanged(name: String, description: String, website: String)
}

final class EditProfilePresenter: EditProfilePresenterProtocol {
    weak var viewController: EditProfileViewController?
    private var service: EditProfileServiceProtocol?

    init(viewController: EditProfileViewController) {
        self.viewController = viewController
        self.service = ProfileService2.shared
    }
    func setNewAvata(url: String) {
        service?.newAvatarURL = url
    }

    func profileChanged(name: String, description: String, website: String) {
        UIBlockingProgressHUD.show()
        service?.putProfile(name: name,
                            description: description,
                            website: website) { result in
            switch result {
            case .success(let result):
                UIBlockingProgressHUD.dismiss()
                ProfileViewController.shared.helper?.updateProfileView()
                print(result)
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                print(error)
            }
        }
    }
}
