//
//  ProfileHelper.swift
//  FakeNFT
//
//  Created by Владимир Клевцов on 16.1.24..
//

import Foundation

protocol ProfileHelperProtocol {
    func updateProfileView()
}

final class ProfileHelper: ProfileHelperProtocol {

    private let profileService = ProfileService.shared
    private weak var profileViewController: ProfileViewController?

    init(viewController: ProfileViewController) {
        self.profileViewController = viewController
    }

    func updateProfileView() {
        profileViewController?.userNameLabel.text = profileService.userName
        profileViewController?.descriptionLabel.text = profileService.userDescription
        profileViewController?.linkLabel.text = profileService.website
        guard let profileURL = profileService.oldAvatarURL,
              let url = URL(string: profileURL) else { return }
        profileViewController?.userImage.kf.setImage(with: url)
    }
}
