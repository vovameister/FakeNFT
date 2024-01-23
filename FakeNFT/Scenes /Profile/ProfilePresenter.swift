//
//  ProfilePresenter.swift
//  FakeNFT
//
//  Created by Владимир Клевцов on 15.1.24..
//
import Foundation

final class ProfilePresenter {
    private let profileService = ProfileService.shared
    weak var viewController: ProfileViewController?

    init(viewController: ProfileViewController) {
        self.viewController = viewController
    }
    func presentEdit() {
            let editProfileViewController = EditProfileViewController()
            viewController?.present(editProfileViewController, animated: true, completion: nil)
        }
}
