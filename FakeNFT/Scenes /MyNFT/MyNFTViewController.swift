//
//  MyNFTViewController.swift
//  FakeNFT
//
//  Created by Владимир Клевцов on 23.1.24..
//

import UIKit

final class MyNFTViewController: UIViewController {
    private let titleView = UILabel()
    private let buttonBack = UIButton()
    private let filterButton = UIButton()
    private let tableView = UITableView()

    private let cellIdentifier = "NFTCell"

    override func viewDidLoad() {
        setUpView()
        setUpTableView()
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

    @objc func tapBack() {
        dismiss(animated: true)
    }
}

extension MyNFTViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MyNFTCell
        else {
            return UITableViewCell()
        }

        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
}
