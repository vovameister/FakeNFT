//
//  ProfileHelper.swift
//  FakeNFT
//
//  Created by Владимир Клевцов on 16.1.24..
//

import Foundation

protocol ProfileHelperProtocol {
    func updateProfileView()
    var sumNFT: Int? { get }
    var sumLikes: Int? { get }
}

final class ProfileHelper: ProfileHelperProtocol {

    private var service: PropfileServiceProtocol?
    private weak var profileViewController: ProfileViewController?

    var sumNFT: Int?
    var sumLikes: Int?

    init(viewController: ProfileViewController) {
        self.profileViewController = viewController
        self.service = ProfileService2.shared
    }

    func updateProfileView() {
        UIBlockingProgressHUD.show()
        service?.loadProfile { [weak self] result in
            switch result {
            case .success(let profile):
                self?.getProfile(profile: profile)
                UIBlockingProgressHUD.dismiss()
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                print(error)
            }
        }
    }
    func getProfile(profile: Profile) {
        profileViewController?.userNameLabel.text = profile.name
        profileViewController?.descriptionLabel.text = profile.description
        profileViewController?.linkLabel.text = profile.website
        self.sumNFT = profile.nfts?.count
        self.sumLikes = profile.likes?.count
        guard let profileURL = profile.avatar,
              let url = URL(string: profileURL) else { return }
        profileViewController?.userImage.kf.setImage(with: url)
        profileViewController?.tableView.reloadData()
    }
}
