//
//  PrifileViewController.swift
//  FakeNFT
//
//  Created by Владимир Клевцов on 15.1.24..
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    static let shared = ProfileViewController()

    private var presenter: ProfilePresenterProtocol?

    var helper: ProfileHelperProtocol?

    let editButton = UIButton()
    let userImage = UIImageView()
    let userNameLabel = UILabel()
    let descriptionLabel = UITextView()
    let linkLabel = UILabel()
    let tableView = UITableView()

    private let tableText: [String] = [NSLocalizedString("myNFT", comment: ""),
                                       NSLocalizedString("favorites", comment: ""),
                                       NSLocalizedString("aboutDev", comment: "")]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.background
        setUpView()
        setUpCostraints()

        helper = ProfileHelper(viewController: self)

        helper?.updateProfileView()
    }

    @objc func presentWeb(gesture: UITapGestureRecognizer) {
        if let urlString = linkLabel.text, let url = URL(string: "https://" + urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    @objc func editTap() {
        presenter?.presentEdit()
    }
    private func setUpView() {
        presenter = ProfilePresenter(viewController: self)

        editButton.translatesAutoresizingMaskIntoConstraints = false
        editButton.setImage(UIImage(named: "editProfile"), for: .normal)
        editButton.addTarget(self, action: #selector(editTap), for: .touchUpInside)
        view.addSubview(editButton)

        userImage.translatesAutoresizingMaskIntoConstraints = false
        userImage.backgroundColor = .elementsBG
        userImage.layer.cornerRadius = 35
        userImage.clipsToBounds = true
        view.addSubview(userImage)

        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.text = "hoakin phenix"
        userNameLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        view.addSubview(userNameLabel)

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        descriptionLabel.isEditable = false
        view.addSubview(descriptionLabel)

        linkLabel.isUserInteractionEnabled = true
        linkLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(presentWeb(gesture:))))
        view.addSubview(linkLabel)
        linkLabel.translatesAutoresizingMaskIntoConstraints = false
        linkLabel.attributedText = NSAttributedString(
            string: "",
            attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])

        linkLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        linkLabel.textColor = UIColor.blueUniversal

        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.separatorStyle = .none
        view.addSubview(tableView)
    }
    func setUpCostraints() {
        NSLayoutConstraint.activate([
            editButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            editButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 54),
            editButton.heightAnchor.constraint(equalToConstant: 42),
            editButton.widthAnchor.constraint(equalToConstant: 42),

            userImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 108),
            userImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userImage.widthAnchor.constraint(equalToConstant: 70),
            userImage.heightAnchor.constraint(equalToConstant: 70),

            userNameLabel.leadingAnchor.constraint(equalTo: userImage.trailingAnchor, constant: 16),
            userNameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            userNameLabel.centerYAnchor.constraint(equalTo: userImage.centerYAnchor),
            userNameLabel.heightAnchor.constraint(equalToConstant: 28),

            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -18),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 72),
            descriptionLabel.topAnchor.constraint(equalTo: userImage.bottomAnchor, constant: 20),

            linkLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            linkLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            linkLabel.heightAnchor.constraint(equalToConstant: 20),
            linkLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 12),

            tableView.topAnchor.constraint(equalTo: linkLabel.bottomAnchor, constant: 44),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -304)
        ])
    }

}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if indexPath.row == 0 {
            cell.textLabel?.text = "\(tableText[indexPath.row]) (\(mockSum))"
        } else if indexPath.row == 1 {
            cell.textLabel?.text = "\(tableText[indexPath.row]) (\(mockSum))"
        } else {
            cell.textLabel?.text = tableText[indexPath.row]
        }
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        let accessoryImageView = UIImageView(image: UIImage(systemName: "chevron.right"))

        accessoryImageView.tintColor = .elementsBG
        cell.accessoryView = accessoryImageView

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height / 3
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let viewController = MyNFTViewController()
            viewController.modalPresentationStyle = .fullScreen
            viewController.modalTransitionStyle = .crossDissolve
            present(viewController, animated: true, completion: nil)
        } else if indexPath.row == 1 {
            let viewController = FeaturedNFTViewController()
            viewController.modalPresentationStyle = .fullScreen
            viewController.modalTransitionStyle = .crossDissolve
            present(viewController, animated: true, completion: nil)
        }
    }
}

private let mockSum = 100
