//
//  EditProfimePresenter.swift
//  FakeNFT
//
//  Created by Владимир Клевцов on 16.1.24..
//

import UIKit
import Kingfisher

final class EditProfilePresenter {
    static let DidChangeNotification = Notification.Name(rawValue: "ProfilerDidChange")
    
    weak var viewController: EditProfileViewController?
    let service = ProfileService.shared
    
    init(viewController: EditProfileViewController) {
        self.viewController = viewController
    }
    
    func openImageLinkInput() {
        let alertController = UIAlertController(title: "Вставьте ссылку на изображение",
                                                message: nil,
                                                preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Ссылка"
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            if let imageLink = alertController.textFields?.first?.text {
                self.setImageFromURL(imageLink)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Назад", style: .cancel, handler: nil)
        
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        viewController?.present(alertController, animated: true, completion: nil)
    }
    func setImageFromURL(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            let alert = UIAlertController(
                title: "Invalid URL",
                message: "Please enter a valid image URL",
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            viewController?.present(alert, animated: true, completion: nil)
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

