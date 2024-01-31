//
//  EditProfileHelper.swift
//  FakeNFT
//
//  Created by Владимир Клевцов on 17.1.24..
//

import Foundation

protocol EditProfileHelperProtocol {
    func updateEditProfile()
}

final class EditProfileHelper: EditProfileHelperProtocol {
    private let profileService = ProfileService.shared
    private weak var profileViewController: EditProfileViewController?

    init(viewController: EditProfileViewController) {
        self.profileViewController = viewController
    }

    func updateEditProfile() {
        profileViewController?.nameField.text = profileService.userName
        profileViewController?.descriptionTextView.text = profileService.userDescription
        profileViewController?.webTextView.text = profileService.website
        guard let profileURL = profileService.oldAvatarURL,
              let url = URL(string: profileURL) else { return }
        profileViewController?.userImage.kf.setImage(with: url)
    }
}
