//
//  StatisticsTableCell.swift
//  FakeNFT
//
//  Created by Ramilia on 20/01/24.
//

import UIKit

final class StatisticsTableCell: UITableViewCell, ReuseIdentifying {
    
    static let defaultReuseIdentifier = "statisticsCell"
    
    //MARK: UI elements
    private lazy var indexLabel: UILabel = {
        let label = UILabel()
        label.font = .caption1
        label.text = "1" //debug
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let infoView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 12
        view.clipsToBounds = true
        view.backgroundColor = .segmentInactive
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var userAvatarImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 14
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemPink //debug
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .headline3
        label.numberOfLines = 2
        label.text = "Alex Timoti" //debug
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var countsNFTLabel: UILabel = {
        let label = UILabel()
        label.font = .headline3
        label.text = "112" //debug
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addViews()
    }
    
    required init?(coder: NSCoder) {
        
        assertionFailure("init(coder:) has not been implemented")
        return nil
    }
    
    //MARK: layout
    private func addViews() {
        
        backgroundColor = .background
        
        contentView.addSubview(indexLabel)
        contentView.addSubview(infoView)
        infoView.addSubview(userAvatarImage)
        infoView.addSubview(userNameLabel)
        infoView.addSubview(countsNFTLabel)
        
        NSLayoutConstraint.activate([
            
            indexLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            indexLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
         
            infoView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            infoView.leadingAnchor.constraint(equalTo: indexLabel.trailingAnchor, constant: 8),
            infoView.trailingAnchor.constraint(equalTo: trailingAnchor),
            infoView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            
            userAvatarImage.leadingAnchor.constraint(equalTo: infoView.leadingAnchor, constant: 16),
            userAvatarImage.heightAnchor.constraint(equalToConstant: 28),
            userAvatarImage.widthAnchor.constraint(equalToConstant: 28),
            userAvatarImage.centerYAnchor.constraint(equalTo: infoView.centerYAnchor),
            
            userNameLabel.leadingAnchor.constraint(equalTo: userAvatarImage.trailingAnchor, constant: 8),
            userNameLabel.centerYAnchor.constraint(equalTo: infoView.centerYAnchor),
            
            countsNFTLabel.trailingAnchor.constraint(equalTo: infoView.trailingAnchor, constant: -16),
            countsNFTLabel.centerYAnchor.constraint(equalTo: infoView.centerYAnchor)
        ])
    }
    
    func updateInfo(index: Int) {
        indexLabel.text = String(index + 1)
    }
}
