//
//  UserNftCell.swift
//  FakeNFT
//
//  Created by Ramilia on 31/01/24.
//

import Kingfisher
import UIKit

final class UserNftCell: UICollectionViewCell, ReuseIdentifying {
    
    static let defaultReuseIdentifier = "userNftCell"
    private var starsView: [UIImageView] = []
    
    //MARK: - UI elements
    
    private lazy var nftImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.layer.cornerRadius = 12
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var ratingStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 2
        for index in 0...4 {
            let imageView = UIImageView()
            starsView.append(imageView)
            stack.addArrangedSubview(imageView)
        }
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var likeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "like_disable")
        imageView.contentMode = .center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var subView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.font = .caption3
        label.textColor = .textColor
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var basketButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "basket") ?? UIImage(), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
    
    //MARK: - Layout
    
    private func setupViews(){
        backgroundColor = .systemBackground
        
        contentView.addSubview(nftImage)
        contentView.addSubview(likeImageView)
        contentView.addSubview(ratingStack)
        contentView.addSubview(subView)
        subView.addSubview(basketButton)
        subView.addSubview(nameLabel)
        subView.addSubview(priceLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            nftImage.topAnchor.constraint(equalTo: topAnchor),
            nftImage.widthAnchor.constraint(equalToConstant: 108),
            nftImage.heightAnchor.constraint(equalToConstant: 108),
            
            likeImageView.topAnchor.constraint(equalTo: topAnchor),
            likeImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            likeImageView.heightAnchor.constraint(equalToConstant: 40),
            likeImageView.widthAnchor.constraint(equalToConstant: 40),
            
            ratingStack.topAnchor.constraint(equalTo: nftImage.bottomAnchor, constant: 8),
            ratingStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            ratingStack.heightAnchor.constraint(equalToConstant: 12),
            ratingStack.widthAnchor.constraint(equalToConstant: 68),
            
            subView.topAnchor.constraint(equalTo: ratingStack.bottomAnchor, constant: 4),
            subView.leadingAnchor.constraint(equalTo: leadingAnchor),
            subView.trailingAnchor.constraint(equalTo: trailingAnchor),
            subView.heightAnchor.constraint(equalToConstant: 40),
            
            basketButton.topAnchor.constraint(equalTo: subView.topAnchor),
            basketButton.trailingAnchor.constraint(equalTo: subView.trailingAnchor),
            basketButton.bottomAnchor.constraint(equalTo: subView.bottomAnchor),
            basketButton.widthAnchor.constraint(equalToConstant: 40),
            
            nameLabel.topAnchor.constraint(equalTo: subView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: subView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: basketButton.leadingAnchor),
            
            priceLabel.leadingAnchor.constraint(equalTo: subView.leadingAnchor),
            priceLabel.bottomAnchor.constraint(equalTo: subView.bottomAnchor)
        ])
    }
    
    //MARK: - Functions
    
    private func setStars(to rating: Int) {
        for (index, imageView) in starsView.enumerated() {
            let namedImage = index < rating ? "star_enable": "star_disable"
            imageView.image = UIImage(named: namedImage)
        }
    }
    
    func configure(with nft: UserNftCellModel) {
        nftImage.kf.setImage(with: nft.image)
        nameLabel.text = nft.name
        priceLabel.text = "\(nft.price) ETH"
        setStars(to: nft.rating)
    }
}
