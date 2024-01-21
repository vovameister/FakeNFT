//
//  CatalogTableViewCell.swift
//  FakeNFT
//
//  Created by Artem Dubovitsky on 21.01.2024.
//
import UIKit

final class CatalogTableViewCell: UITableViewCell, ReuseIdentifying {
    
    // MARK: - Cell-Elements
    private lazy var catalogImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 12
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private lazy var catalogLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .textPrimary
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        setupCatalogTableViewCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Setup View
    private func setupCatalogTableViewCell() {
        backgroundColor = .clear
        selectionStyle = .none
        addSubviews()
        setupCatalogTableViewCellConstrains()
    }
    
    private func addSubviews() {
        [catalogImage,
         catalogLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
    }
    
    private func setupCatalogTableViewCellConstrains() {
        NSLayoutConstraint.activate([
            catalogImage.heightAnchor.constraint(equalToConstant: 140),
            catalogImage.topAnchor.constraint(equalTo: topAnchor),
            catalogImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            catalogImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            catalogLabel.topAnchor.constraint(equalTo: catalogImage.bottomAnchor, constant: 4),
            catalogLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            catalogLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            catalogLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -13)
        ])
    }
}
