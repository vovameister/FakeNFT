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
        image.backgroundColor = .blue // test
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    private lazy var catalogLabel: UILabel = {
        let label = UILabel()
        label.font = .bodyBold
        label.textColor = .textPrimary
        label.text = "Blue (5)" // test
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
            catalogImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            catalogImage.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            
            catalogLabel.topAnchor.constraint(equalTo: catalogImage.bottomAnchor, constant: 4),
            catalogLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            catalogLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            catalogLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -13)
        ])
    }
}
