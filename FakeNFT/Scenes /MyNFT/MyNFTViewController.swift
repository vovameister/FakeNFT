//
//  MyNFTViewController.swift
//  FakeNFT
//
//  Created by Владимир Клевцов on 23.1.24..
//

import UIKit
import Kingfisher

final class MyNFTViewController: UIViewController {
    private var helper: MyNFTHelperProtocol?
    private var presenter: MyNFTPresenterProtocol?

    private let titleView = UILabel()
    private let buttonBack = UIButton()
    private let filterButton = UIButton()
    let tableView = UITableView()

    private let cellIdentifier = "NFTCell"

    let noNFTLabel = UILabel()
    override func viewDidLoad() {
        helper = MyNFTHelper(viewController: self)

        setUpView()
        setUpTableView()
        setUpNoNFTLabel()

        presenter = MyNFTPresenter()
        helper?.showNoFavoriteLabel()
    }
    private func setUpView() {
        view.backgroundColor = .background

        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.text = NSLocalizedString("myNFT", comment: "")
        titleView.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        titleView.textColor = .elementsBG
        view.addSubview(titleView)

        buttonBack.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        buttonBack.tintColor = .elementsBG
        buttonBack.translatesAutoresizingMaskIntoConstraints = false
        buttonBack.addTarget(self, action: #selector(tapBack), for: .touchUpInside)
        view.addSubview(buttonBack)

        filterButton.translatesAutoresizingMaskIntoConstraints = false
        filterButton.setImage(UIImage(systemName: "text.justify.leading"), for: .normal)
        filterButton.tintColor = .elementsBG
        filterButton.addTarget(self, action: #selector(showFiltersAlert), for: .touchUpInside)
        view.addSubview(filterButton)

        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: view.topAnchor, constant: 56),
            titleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleView.heightAnchor.constraint(equalToConstant: 22),

            buttonBack.topAnchor.constraint(equalTo: view.topAnchor, constant: 55),
            buttonBack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),
            buttonBack.heightAnchor.constraint(equalToConstant: 24),
            buttonBack.widthAnchor.constraint(equalToConstant: 24),

            filterButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 46),
            filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -9),
            filterButton.widthAnchor.constraint(equalToConstant: 42),
            filterButton.heightAnchor.constraint(equalToConstant: 42)
        ])
    }
    func setUpTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MyNFTCell.self, forCellReuseIdentifier: cellIdentifier)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 30),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.heightAnchor.constraint(equalToConstant: 700)
        ])
    }
    func setUpNoNFTLabel() {
        noNFTLabel.translatesAutoresizingMaskIntoConstraints = false
        noNFTLabel.text = NSLocalizedString("noNFT", comment: "")
        noNFTLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        noNFTLabel.textAlignment = .center
        noNFTLabel.textColor = .elementsBG
        view.addSubview(noNFTLabel)

        NSLayoutConstraint.activate([
            noNFTLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noNFTLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    @objc func tapBack() {
        dismiss(animated: true)
        ProfileViewController.shared.helper?.realodTableView()
    }
    @objc func changeLike() {

    }
}

extension MyNFTViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        helper?.nuberOfCell() ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MyNFTCell
        else {
            return UITableViewCell()
        }
        let nft = helper?.updateTableView(indexPath: indexPath)

        cell.authorLabel.text = nft?.author
        cell.nameLabel.text = nft?.name
        cell.priceLabel.text = "\(String(describing: nft?.price ?? 0)) ETH"
        cell.starsImage.image = UIImage(named: "stars\(String(describing: nft?.rating ?? 0))")
        cell.delegate = self
        cell.selectionStyle = .none

        cell.likeButton.tintColor = (presenter?.isLike(indexPath: indexPath))! ? .NFTRed : .white

        if let urlSting = nft?.images.first {
            let url = URL(string: urlSting)
            cell.nftImage.kf.setImage(with: url)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
}

extension MyNFTViewController {
    @objc func showFiltersAlert() {
        let alertController = UIAlertController(title: nil,
                                                message: NSLocalizedString("sort", comment: ""),
                                                preferredStyle: .actionSheet)

        let byPrice = UIAlertAction(title: NSLocalizedString("byPrice", comment: ""),
                                    style: .default) { (_) in
            self.presenter?.sortByPrice()
            self.tableView.reloadData()
        }
        let byRating = UIAlertAction(title: NSLocalizedString("byRating", comment: ""),
                                     style: .default) { (_) in
            self.presenter?.sortByRating()
            self.tableView.reloadData()
        }
        let byName = UIAlertAction(title: NSLocalizedString("byName", comment: ""),
                                   style: .default) { (_) in
            self.presenter?.sortByName()
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("close", comment: ""),
                                         style: .cancel, handler: nil)

        alertController.addAction(byPrice)
        alertController.addAction(byRating)
        alertController.addAction(byName)
        alertController.addAction(cancelAction)

        present(alertController, animated: true, completion: nil)
    }
}

extension MyNFTViewController: MyNFTCellDelegate {
    func likeButtonTap(cell: MyNFTCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        if presenter?.isLikeTap(indexPath: indexPath) == true {
            cell.likeButton.tintColor = .white
        } else {
            cell.likeButton.tintColor = .NFTRed
        }

    }

}
