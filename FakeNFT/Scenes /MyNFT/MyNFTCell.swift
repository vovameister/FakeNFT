//
//  MyNFTCell.swift
//  FakeNFT
//
//  Created by Владимир Клевцов on 23.1.24..
//

import UIKit
protocol MyNFTCellDelegate: AnyObject {
    func likeButtonTap(cell: MyNFTCell)
}

final class MyNFTCell: UITableViewCell {
    weak var delegate: MyNFTCellDelegate?

    let nftImage = UIImageView()
    let nameLabel = UILabel()
    let starsImage = UIImageView()
    let fromLabel = UILabel()
    let authorLabel = UILabel()
    let priceTitle = UILabel()
    let priceLabel = UILabel()
    let likeButton = UIButton()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpView()
        setUpCostraints()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
        setUpCostraints()
    }

    func setUpView() {

        nftImage.image = UIImage(named: "NFTcard")
        nftImage.translatesAutoresizingMaskIntoConstraints = false
        nftImage.layer.cornerRadius = 12
        nftImage.clipsToBounds = true
        contentView.addSubview(nftImage)

        nameLabel.text = "lie"

        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        likeButton.tintColor = .white
        likeButton.addTarget(self, action: #selector(tapLike), for: .touchUpInside)
        contentView.addSubview(likeButton)

        nameLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        nameLabel.textColor = .elementsBG
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameLabel)

        starsImage.translatesAutoresizingMaskIntoConstraints = false
        starsImage.image = UIImage(named: "stars5")
        contentView.addSubview(starsImage)

        fromLabel.translatesAutoresizingMaskIntoConstraints = false
        fromLabel.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        fromLabel.text = NSLocalizedString("from", comment: "")
        contentView.addSubview(fromLabel)

        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        contentView.addSubview(authorLabel)

        priceTitle.translatesAutoresizingMaskIntoConstraints = false
        priceTitle.text = NSLocalizedString("price", comment: "")
        priceTitle.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        contentView.addSubview(priceTitle)

        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        contentView.addSubview(priceLabel)
    }

    func setUpCostraints() {
        NSLayoutConstraint.activate([
            nftImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            nftImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            nftImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16),
            nftImage.widthAnchor.constraint(equalTo: nftImage.heightAnchor),

            likeButton.topAnchor.constraint(equalTo: nftImage.topAnchor, constant: 1),
            likeButton.trailingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: -1),
            likeButton.heightAnchor.constraint(equalToConstant: 42),
            likeButton.widthAnchor.constraint(equalToConstant: 42),

            nameLabel.leadingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: 20),
            nameLabel.topAnchor.constraint(equalTo: nftImage.topAnchor, constant: 26),
            nameLabel.bottomAnchor.constraint(equalTo: nftImage.bottomAnchor, constant: -63),
            nameLabel.widthAnchor.constraint(equalToConstant: 80),

            starsImage.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            starsImage.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4),
            starsImage.widthAnchor.constraint(equalToConstant: 68),
            starsImage.heightAnchor.constraint(equalToConstant: 12),

            fromLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            fromLabel.topAnchor.constraint(equalTo: starsImage.bottomAnchor, constant: 4),
            fromLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -39),

            authorLabel.leadingAnchor.constraint(equalTo: fromLabel.trailingAnchor, constant: 4),
            authorLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40),
            authorLabel.widthAnchor.constraint(equalToConstant: 95),

            priceTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 49),
            priceTitle.leadingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: 137),

            priceLabel.leadingAnchor.constraint(equalTo: priceTitle.leadingAnchor),
            priceLabel.topAnchor.constraint(equalTo: priceTitle.bottomAnchor, constant: 2)
        ])
    }
    @objc func tapLike() {
        delegate?.likeButtonTap(cell: self)
    }
}
