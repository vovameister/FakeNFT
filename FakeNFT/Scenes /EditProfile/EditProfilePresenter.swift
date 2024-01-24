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
    let service = ProfileService.shared

    init(viewController: EditProfileViewController) {
        self.viewController = viewController
    }
    func setNewAvata(url: String) {
        service.newAvatarURL = url
    }

    func profileChanged(name: String, description: String, website: String) {
        service.userName = name
        service.website = website
        service.userDescription = description
        service.saveAvater()
        ProfileViewController.shared.helper?.updateProfileView()
    }
}
