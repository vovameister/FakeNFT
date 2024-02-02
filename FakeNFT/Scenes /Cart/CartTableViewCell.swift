//
//  CartTableViewCell.swift
//  FakeNFT
//
//  Created by Кира on 28.01.2024.
//

import UIKit
import Kingfisher

final class CartTableViewCell: UITableViewCell {
    
    static let reuseId = "cartCell"
    var nftId: String = ""
    weak var delegate: CartViewControllerDelegate?
    
    private lazy var nameLabel: UILabel =  {
        let label = UILabel()
        label.textColor = UIColor.ypBlack
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var nftImage: UIImageView  = {
        let image = UIImageView()
        image.layer.cornerRadius = 12
        image.layer.masksToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    private lazy var priceLabel: UILabel =  {
        let label = UILabel()
        label.textColor = UIColor.ypBlack
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceHeaderLabel: UILabel =  {
        let label = UILabel()
        label.textColor = UIColor.ypBlack
        label.text = NSLocalizedString("Cart.price", comment: "")
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var deleteButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "deleteButton"), for: .normal)
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var ratingControl = RatingControl()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCell(with nft: Nft) {
        nftId = nft.id
        nameLabel.text = nft.name
        priceLabel.text = "\(nft.price) ETH"
        nftImage.kf.setImage(with: nft.images.first, placeholder: UIImage(named: "Vector"))
        ratingControl.rating = nft.rating
    }
    
    private func prepareView() {
        addSubview(nameLabel)
        addSubview(nftImage)
        addSubview(priceLabel)
        addSubview(priceHeaderLabel)
        contentView.addSubview(deleteButton)
        addSubview(ratingControl)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            nftImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            nftImage.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            nftImage.heightAnchor.constraint(equalToConstant: 108),
            nftImage.widthAnchor.constraint(equalToConstant: 108),
            
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            nameLabel.leadingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: 20),
            
            ratingControl.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            ratingControl.leadingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: 20),
            
            priceHeaderLabel.leadingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: 20),
            priceHeaderLabel.topAnchor.constraint(equalTo: ratingControl.bottomAnchor, constant: 12),
            
            priceLabel.leadingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: 20),
            priceLabel.topAnchor.constraint(equalTo: priceHeaderLabel.bottomAnchor, constant: 2),
            
            deleteButton.topAnchor.constraint(equalTo: topAnchor, constant: 50),
            deleteButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            deleteButton.heightAnchor.constraint(equalToConstant: 40),
            deleteButton.widthAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc private func deleteButtonTapped() {
        print("delete button tapped")
        delegate?.didTapCellDeleteButton(with: nftId)
    }
}
