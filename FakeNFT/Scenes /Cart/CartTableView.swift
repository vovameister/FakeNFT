//
//  CartTableView.swift
//  FakeNFT
//
//  Created by Кира on 28.01.2024.
//

import UIKit

final class CartTableView: UITableView {
    private var nftsInCart: [Nft] = []
    
    weak var cartDelegate: CartViewControllerDelegate?
    
    init() {
        super.init(frame: .zero, style: .plain)
        translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        delegate = self
        dataSource = self
        separatorStyle = .none
        allowsSelection = false
        register(CartTableViewCell.self, forCellReuseIdentifier: CartTableViewCell.reuseId)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureTableView(nfts: [Nft]) {
        nftsInCart = nfts
        self.reloadData()
    }
}

extension CartTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nftsInCart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = self.dequeueReusableCell(withIdentifier: CartTableViewCell.reuseId) as? CartTableViewCell else { return UITableViewCell()}
        cell.configureCell(with: nftsInCart[indexPath.row])
        cell.delegate = cartDelegate
        return cell
    }
}

extension CartTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
}
