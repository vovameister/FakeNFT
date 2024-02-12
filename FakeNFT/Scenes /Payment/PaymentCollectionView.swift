//
//  PaymentCollectionView.swift
//  FakeNFT
//
//  Created by Кира on 29.01.2024.
//

import UIKit

final class PaymentCollectionView: UICollectionView {
    private var currencies: [CurrencyModel] = []
    weak var paymentDelegate: PaymentViewControllerDelegate?
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.allowsMultipleSelection = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    func configureCollectionView(currs: [CurrencyModel]) {
        currencies = currs
        self.reloadData()
    }
    
    init() {
        let layout = UICollectionViewFlowLayout()
        super.init(frame: .zero, collectionViewLayout: layout)
        delegate = self
        dataSource = self
        backgroundColor = UIColor.ypWhite
        register(PaymentViewCell.self, forCellWithReuseIdentifier: PaymentViewCell.reuseId)
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PaymentCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - 39
        let cellWidth =  availableWidth / CGFloat(2)
        return CGSize(width: cellWidth, height: 46)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 7
    }
}

extension PaymentCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currencies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: PaymentViewCell.reuseId, for: indexPath) as? PaymentViewCell else { return UICollectionViewCell()}
        cell.configureCell(currency: currencies[indexPath.row])
        return cell
    }
}

extension PaymentCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = cellForItem(at: indexPath) as? PaymentViewCell
        cell?.delegate = self
        cell?.didSelectCell(with: currencies[indexPath.row].id)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = cellForItem(at: indexPath) as? PaymentViewCell
        cell?.delegate = self
        cell?.didDeselectCell()
    }
}

extension PaymentCollectionView: PaymentViewCellDelegate {
    func didSelectCurrency(with id: String) {
        paymentDelegate?.didSelectCurrency(with: id)
    }
    
    func didDeselectCurrency() {
        paymentDelegate?.didDeselectCurrency()
    }
}
