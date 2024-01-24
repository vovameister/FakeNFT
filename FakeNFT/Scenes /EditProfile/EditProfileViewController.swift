//
//  EditProfileViewController.swift
//  FakeNFT
//
//  Created by Владимир Клевцов on 15.1.24..
//

import UIKit
import Kingfisher

final class EditProfileViewController: UIViewController {
    private var presenter: EditProfilePresenterProtocol?
    private var helper: EditProfileHelperProtocol?

    private let closeButton = UIButton()
    private let namelabel = UILabel()
    private let webLabel = UILabel()
    private let descriptionLabel = UILabel()

    let nameField = UITextField()
    let descriptionTextView = UITextView()
    let webTextView = UITextView()

    let userImage = UIImageView()
    let userImageChangeButton = UIButton()

    override func viewDidLoad() {
        view.backgroundColor = .background

        setUpView()

        presenter = EditProfilePresenter(viewController: self)
        helper = EditProfileHelper(viewController: self)

        helper?.updateEditProfile()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    private func setUpView() {
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setImage(UIImage(named: "xImage"), for: .normal)
        closeButton.addTarget(self, action: #selector(closeEdit), for: .touchUpInside)
        view.addSubview(closeButton)

        userImage.translatesAutoresizingMaskIntoConstraints = false
        userImage.layer.cornerRadius = 35
        userImage.backgroundColor = .elementsBG
        userImage.clipsToBounds = true
        view.addSubview(userImage)

        userImageChangeButton.translatesAutoresizingMaskIntoConstraints = false
        userImageChangeButton.layer.cornerRadius = 35
        userImageChangeButton.backgroundColor = UIColor(named: "avatarShadow")
        userImageChangeButton.addTarget(self, action: #selector(openImageLinkInput), for: .touchUpInside)

        userImageChangeButton.setTitle(NSLocalizedString("changePhoto", comment: ""), for: .normal)
        userImageChangeButton.titleLabel?.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        userImageChangeButton.titleLabel?.numberOfLines = 2
        userImageChangeButton.titleLabel?.textAlignment = .center
        userImageChangeButton.titleLabel?.contentMode = .top
        view.addSubview(userImageChangeButton)

        namelabel.translatesAutoresizingMaskIntoConstraints = false
        namelabel.text = NSLocalizedString("name", comment: "")
        namelabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        view.addSubview(namelabel)

        nameField.translatesAutoresizingMaskIntoConstraints = false
        nameField.backgroundColor = .fieldBg
        nameField.layer.cornerRadius = 12
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        nameField.leftView = leftPaddingView
        nameField.leftViewMode = .always
        nameField.clearButtonMode = .whileEditing
        nameField.font = UIFont.systemFont(ofSize: 17, weight: .regular)

        nameField.delegate = self
        view.addSubview(nameField)

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.text = NSLocalizedString("description", comment: "")
        descriptionLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        view.addSubview(descriptionLabel)

        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.backgroundColor = .fieldBg
        descriptionTextView.layer.cornerRadius = 12
        descriptionTextView.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        descriptionTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        view.addSubview(descriptionTextView)

        webLabel.translatesAutoresizingMaskIntoConstraints = false
        webLabel.text = NSLocalizedString("website", comment: "")
        webLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        view.addSubview(webLabel)

        webTextView.translatesAutoresizingMaskIntoConstraints = false
        webTextView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 0)
        webTextView.backgroundColor = .fieldBg
        webTextView.layer.cornerRadius = 12
        webTextView.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        webTextView.textContainer.maximumNumberOfLines = 1
        view.addSubview(webTextView)

        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 42),
            closeButton.heightAnchor.constraint(equalToConstant: 42),

            userImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 94),
            userImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userImage.widthAnchor.constraint(equalToConstant: 70),
            userImage.heightAnchor.constraint(equalToConstant: 70),

            userImageChangeButton.topAnchor.constraint(equalTo: userImage.topAnchor),
            userImageChangeButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userImageChangeButton.widthAnchor.constraint(equalToConstant: 70),
            userImageChangeButton.heightAnchor.constraint(equalToConstant: 70),

            namelabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            namelabel.topAnchor.constraint(equalTo: userImageChangeButton.bottomAnchor, constant: 24),
            namelabel.widthAnchor.constraint(equalToConstant: 80),
            namelabel.heightAnchor.constraint(equalToConstant: 28),

            nameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            nameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            nameField.topAnchor.constraint(equalTo: namelabel.bottomAnchor, constant: 8),
            nameField.heightAnchor.constraint(equalToConstant: 44),

            descriptionLabel.topAnchor.constraint(equalTo: nameField.bottomAnchor, constant: 22),
            descriptionLabel.leadingAnchor.constraint(equalTo: namelabel.leadingAnchor),
            descriptionLabel.widthAnchor.constraint(equalToConstant: 120),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 28),

            descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            descriptionTextView.leadingAnchor.constraint(equalTo: nameField.leadingAnchor),
            descriptionTextView.trailingAnchor.constraint(equalTo: nameField.trailingAnchor),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 132),

            webLabel.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 24),
            webLabel.leadingAnchor.constraint(equalTo: namelabel.leadingAnchor),
            webLabel.widthAnchor.constraint(equalToConstant: 100),
            webLabel.heightAnchor.constraint(equalToConstant: 28),

            webTextView.topAnchor.constraint(equalTo: webLabel.bottomAnchor, constant: 8),
            webTextView.leadingAnchor.constraint(equalTo: descriptionTextView.leadingAnchor),
            webTextView.trailingAnchor.constraint(equalTo: descriptionTextView.trailingAnchor),
            webTextView.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    @objc func closeEdit() {
        presenter?.profileChanged(name: nameField.text ?? "",
                                  description: descriptionTextView.text ?? "",
                                  website: webTextView.text ?? "")

        dismiss(animated: true)
    }

    @objc func openImageLinkInput() {
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

        present(alertController, animated: true, completion: nil)
    }
    func setImageFromURL(_ urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        presenter?.setNewAvata(url: urlString)

        let options: KingfisherOptionsInfo = [
            .transition(.fade(0.2)),
            .cacheOriginalImage
        ]

        userImage.kf.setImage(with: url, options: options)
    }
}
extension EditProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
