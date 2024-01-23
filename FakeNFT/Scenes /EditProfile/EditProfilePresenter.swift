//
//  EditProfimePresenter.swift
//  FakeNFT
//
//  Created by Владимир Клевцов on 16.1.24..
//

import Foundation
import Kingfisher

final class EditProfilePresenter {

    weak var viewController: EditProfileViewController?
    let service = ProfileService.shared

    init(viewController: EditProfileViewController) {
        self.viewController = viewController
    }

    func setImageFromURL(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        service.newAvatarURL = urlString

        let options: KingfisherOptionsInfo = [
            .transition(.fade(0.2)),
            .cacheOriginalImage
        ]

        viewController?.userImage.kf.setImage(with: url, options: options)
    }
    func profileChanged(name: String, description: String, website: String) {
        service.userName = name
        service.website = website
        service.userDescription = description
        service.saveAvater()
        ProfileViewController.shared.helper?.updateProfileView()
    }
}
