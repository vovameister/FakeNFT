//
//  CartSortView.swift
//  FakeNFT
//
//  Created by Кира on 02.02.2024.
//

import UIKit

protocol CartSortView {
    func sortOptions(completion: @escaping (SortOption) -> Void)
}

enum SortOption: String {
    case price
    case rating
    case name
}

extension CartSortView where Self: UIViewController {
    func sortOptions(completion: @escaping (SortOption) -> Void) {
        let title = NSLocalizedString("Cart.sort", comment: "")
        let alert = UIAlertController(
            title: title,
            message: nil,
            preferredStyle: .actionSheet
        )
        let priceAction = UIAlertAction(title: NSLocalizedString("Cart.sort.by_price", comment: ""), style: UIAlertAction.Style.default) {_ in
            completion(.price)
        }
        alert.addAction(priceAction)
        
        let ratingAction = UIAlertAction(title: NSLocalizedString("Cart.sort.by_rating", comment: ""), style: UIAlertAction.Style.default) {_ in
            completion(.rating)
        }
        alert.addAction(ratingAction)
        
        let nameAction = UIAlertAction(title: NSLocalizedString("Cart.sort.by_name", comment: ""), style: UIAlertAction.Style.default) {_ in
            completion(.name)
        }
        alert.addAction(nameAction)
        
        let closeAction = UIAlertAction(title: NSLocalizedString("Cart.sort.close", comment: ""), style: UIAlertAction.Style.cancel)
        alert.addAction(closeAction)
        present(alert, animated: true)
    }
}
