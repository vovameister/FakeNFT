//
//  ProfilePresenter.swift
//  FakeNFT
//
//  Created by Владимир Клевцов on 15.1.24..
//
import UIKit

final class ProfilePresenter {
    private let profileService = ProfileService.shared
    weak var viewController: ProfileViewController?
    
    init(viewController: ProfileViewController) {
        self.viewController = viewController
    }
    func presentWeb(gesture: UITapGestureRecognizer) {
        if let urlString = profileService.website, let url = URL(string: "https://" + urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    func presentEdit() {
            let editProfileViewController = EditProfileViewController()
            viewController?.present(editProfileViewController, animated: true, completion: nil)
        }
}
