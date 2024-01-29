//
//  FeaturedNFTViewController.swift
//  FakeNFT
//
//  Created by Владимир Клевцов on 24.1.24..
//

import UIKit

final class FeaturedNFTViewController: UIViewController {
    private var presenter: FeaturedPresenterProtocol?
    private var helper: FeaturedHelperProtocol?

    private let titleView = UILabel()
    private let buttonBack = UIButton()

    let noFavoriteLabel = UILabel()
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: UICollectionViewFlowLayout()
        )
        collectionView.register(FeaturedCell.self, forCellWithReuseIdentifier: "Cell")
        return collectionView
    }()

    override func viewDidLoad() {
        view.backgroundColor = .background

        setUpView()
        setUpCostrints()
        helper = FeaturedHelper(viewController: self)
        presenter = FeaturedPresenter()
        helper?.showNoFavoriteLabel()
    }

    func setUpView() {
        titleView.translatesAutoresizingMaskIntoConstraints = false
        titleView.text = NSLocalizedString("featuredNFT", comment: "")
        titleView.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        titleView.textColor = .elementsBG
        view.addSubview(titleView)

        buttonBack.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        buttonBack.tintColor = .elementsBG
        buttonBack.translatesAutoresizingMaskIntoConstraints = false
        buttonBack.addTarget(self, action: #selector(tapBack), for: .touchUpInside)
        view.addSubview(buttonBack)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)

        noFavoriteLabel.translatesAutoresizingMaskIntoConstraints = false
        noFavoriteLabel.text = NSLocalizedString("noFavorite", comment: "")
        noFavoriteLabel.font = UIFont.systemFont(ofSize: 17, weight: .bold)
        noFavoriteLabel.textAlignment = .center
        noFavoriteLabel.textColor = .elementsBG
        view.addSubview(noFavoriteLabel)
    }
    func setUpCostrints() {
        NSLayoutConstraint.activate([
            titleView.topAnchor.constraint(equalTo: view.topAnchor, constant: 56),
            titleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleView.heightAnchor.constraint(equalToConstant: 22),

            buttonBack.topAnchor.constraint(equalTo: view.topAnchor, constant: 55),
            buttonBack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 9),
            buttonBack.heightAnchor.constraint(equalToConstant: 24),
            buttonBack.widthAnchor.constraint(equalToConstant: 24),

            collectionView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 30),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.heightAnchor.constraint(equalToConstant: 700),

            noFavoriteLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            noFavoriteLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    @objc func tapBack() {
        dismiss(animated: true)
    }
}

extension FeaturedNFTViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        helper?.nuberOfCell() ?? 0
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",
                                                              for: indexPath) as? FeaturedCell ?? FeaturedCell()
        let nft = helper?.updateTableView(indexPath: indexPath)

        cell.nftName.text = nft?.name
        cell.priceLabel.text = "\(String(describing: nft?.price ?? 0)) ETH"
        cell.starsImage.image = UIImage(named: "stars\(String(describing: nft?.rating ?? 0))")
        cell.delegate = self

        cell.likeButton.tintColor = .NFTRed

        if let urlSting = nft?.image {
            let url = URL(string: urlSting)
            cell.nftImage.kf.setImage(with: url)
        }
        return cell
    }
}
extension FeaturedNFTViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (collectionView.frame.width - 7)  / 2, height: 80)
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        20
    }
}
extension FeaturedNFTViewController: FeaturedCellDelegate {
    func likeButtonTap(cell: FeaturedCell) {
        guard let nftName = cell.nftName.text else { return }
        presenter?.isLikeTap(nftName: nftName)
        collectionView.reloadData()
        helper?.showNoFavoriteLabel()
    }
}
