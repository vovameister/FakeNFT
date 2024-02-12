//
//  PaymentViewCell.swift
//  FakeNFT
//
//  Created by Кира on 29.01.2024.
//

import UIKit
import Kingfisher

protocol PaymentViewCellDelegate: AnyObject {
    func didSelectCurrency(with id: String)
    func didDeselectCurrency()
}

final class PaymentViewCell: UICollectionViewCell {
    
    static let reuseId = "paymentCell"
    weak var delegate: PaymentViewCellDelegate?
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.ypBlack
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var currencyNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.ypGreen
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var currencyImageView: UIImageView = {
        let imageView = UIImageView()
//        imageView.image = UIImage(named: "Vector")
        imageView.layer.cornerRadius = 6
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.ypLightGray
        layer.cornerRadius = 16
        layer.masksToBounds = true
        prepareView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func prepareView() {
        addSubview(nameLabel)
        addSubview(currencyImageView)
        addSubview(currencyNameLabel)
        
        NSLayoutConstraint.activate([
            currencyImageView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            currencyImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            currencyImageView.widthAnchor.constraint(equalToConstant: 36),
            currencyImageView.heightAnchor.constraint(equalToConstant: 36),
            
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: currencyImageView.trailingAnchor, constant: 4),
            
            currencyNameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor),
            currencyNameLabel.leadingAnchor.constraint(equalTo: currencyImageView.trailingAnchor, constant: 4)
        ])
    }
    
    func configureCell(currency: CurrencyModel) {
        nameLabel.text = currency.title
        currencyNameLabel.text = currency.name
        print(currency.image)
        currencyImageView.kf.setImage(with: URL(string: currency.image), placeholder: UIImage(named: "Vector"))
    }
    
    func didSelectCell(with id: String) {
        layer.borderColor = UIColor.ypBlack?.cgColor
        layer.borderWidth = 1
        delegate?.didSelectCurrency(with: id)
    }
    
    func didDeselectCell() {
        layer.borderWidth = 0
        delegate?.didDeselectCurrency()
    }
}

