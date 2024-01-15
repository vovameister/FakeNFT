//
//  PrifileViewController.swift
//  FakeNFT
//
//  Created by Владимир Клевцов on 15.1.24..
//

import UIKit

final class ProfileViewController: UIViewController {
    private var presenter: ProfilePresenter?

    
    private let editButton = UIButton()
    private let userImage = UIImageView()
    private let userNameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let linkLabel = UILabel()
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.background
        setUpView()
    }

    @objc func presentWeb(gesture: UITapGestureRecognizer) {
        presenter?.presentWeb(gesture: gesture)
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
        userImage.backgroundColor = .gray
        userImage.layer.cornerRadius = 32
        view.addSubview(userImage)

        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.text = "hoakin phenix"
        userNameLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        view.addSubview(userNameLabel)

        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.text = "Дизайнер из Казани, люблю цифровое искусство и бейглы. В моей коллекции уже 100+ NFT, и еще больше — на моём сайте Открыт к коллаборациям."
        descriptionLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        descriptionLabel.numberOfLines = 4
        view.addSubview(descriptionLabel)

        linkLabel.isUserInteractionEnabled = true
        linkLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(presentWeb(gesture:))))
        view.addSubview(linkLabel)
        linkLabel.translatesAutoresizingMaskIntoConstraints = false
        linkLabel.attributedText = NSAttributedString(string: "instagram.com/vovameister", attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
        linkLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        linkLabel.textColor = UIColor.blueUniversal
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.separatorStyle = .none
        view.addSubview(tableView)
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
            cell.textLabel?.text = "\(tableText[indexPath.row]) (\(sto))"
        } else if indexPath.row == 1 {
            cell.textLabel?.text = "\(tableText[indexPath.row]) (\(sto))"
        } else {
            cell.textLabel?.text = tableText[indexPath.row]
        }
        cell.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        let accessoryImageView = UIImageView(image: UIImage(named: "chevron"))
        cell.accessoryView = accessoryImageView
       
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height / 3
    }
}
private let tableText: [String] = [NSLocalizedString("myNFT", comment: ""),
                                   NSLocalizedString("favorites", comment: ""),
                                   NSLocalizedString("aboutDev", comment: "")]
    
private let sto = 100
