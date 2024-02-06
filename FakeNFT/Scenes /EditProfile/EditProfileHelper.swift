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
    private var service: PropfileServiceProtocol?
    private weak var profileViewController: EditProfileViewController?

    init(viewController: EditProfileViewController) {
        self.profileViewController = viewController
        self.service = ProfileService2.shared
    }

    func updateEditProfile() {
        service?.loadProfile { [weak self] result in
            switch result {
            case .success(let profile):
                self?.getProfile(profile: profile)
            case .failure(let error):
                print(error)
            }
        }
    }
    func getProfile(profile: Profile) {
        profileViewController?.nameField.text = profile.name
        profileViewController?.descriptionTextView.text = profile.description
        profileViewController?.webTextView.text = profile.website
        guard let profileURL = profile.avatar,
              let url = URL(string: profileURL) else { return }
        profileViewController?.userImage.kf.setImage(with: url)
    }
}
