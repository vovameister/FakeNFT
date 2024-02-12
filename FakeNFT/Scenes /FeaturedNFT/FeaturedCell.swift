//
//  FeaturedCell.swift
//  FakeNFT
//
//  Created by Владимир Клевцов on 24.1.24..
//

import UIKit

protocol FeaturedCellDelegate: AnyObject {
    func likeButtonTap(cell: FeaturedCell)
}

final class FeaturedCell: UICollectionViewCell {
    weak var delegate: FeaturedCellDelegate?

    let nftImage = UIImageView()
    let likeButton = UIButton()
    let nftName = UILabel()
    let priceLabel = UILabel()
    let starsImage = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUpView() {
        nftImage.translatesAutoresizingMaskIntoConstraints = false
        nftImage.layer.cornerRadius = 12
        nftImage.clipsToBounds = true
        contentView.addSubview(nftImage)

        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        likeButton.tintColor = .red
        likeButton.addTarget(self, action: #selector(tapLike), for: .touchUpInside)
        contentView.addSubview(likeButton)

        nftName.translatesAutoresizingMaskIntoConstraints = false
        nftName.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        contentView.addSubview(nftName)

        starsImage.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(starsImage)

        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        contentView.addSubview(priceLabel)

        NSLayoutConstraint.activate([
            nftImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nftImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            nftImage.widthAnchor.constraint(equalToConstant: 80),
            nftImage.heightAnchor.constraint(equalToConstant: 80),

            likeButton.topAnchor.constraint(equalTo: nftImage.topAnchor, constant: -6.19),
            likeButton.trailingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: 6.19),
            likeButton.heightAnchor.constraint(equalToConstant: 42),
            likeButton.widthAnchor.constraint(equalToConstant: 42),

            nftName.leadingAnchor.constraint(equalTo: nftImage.trailingAnchor, constant: 12),
            nftName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7),
            nftName.heightAnchor.constraint(equalToConstant: 22),
            nftName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),

            starsImage.topAnchor.constraint(equalTo: nftName.bottomAnchor, constant: 4),
            starsImage.leadingAnchor.constraint(equalTo: nftName.leadingAnchor),

            priceLabel.leadingAnchor.constraint(equalTo: starsImage.leadingAnchor),
            priceLabel.topAnchor.constraint(equalTo: starsImage.bottomAnchor, constant: 8)
        ])
    }
    @objc func tapLike() {
        delegate?.likeButtonTap(cell: self)
    }
}
