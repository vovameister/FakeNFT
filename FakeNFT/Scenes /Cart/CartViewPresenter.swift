//
//  CartViewPresenter.swift
//  FakeNFT
//
//  Created by Кира on 28.01.2024.
//

import Foundation

protocol CartViewPresenterProtocol {
    func viewDidLoad()
    func sortNFTs()
    func didTapCellDeleteButton(with id: String)
    func cleanCart()
}

enum CartDetailState {
    case initial, loading, failed(Error), data([Nft]), empty, delete
}

final class CartViewPresenter: CartViewPresenterProtocol {
    weak var view: CartView?
    var idToDelete: String = ""
    private let service: CartService
    private var state = CartDetailState.initial {
        didSet {
            stateDidChanged()
        }
    }
    
    private var nftsInCart: [Nft] = [] {
        didSet {
            view?.setTableView(nfts: nftsInCart)
        }
    }
    
    private var choosenSortOption = SortOption.name {
        didSet {
            sort(with: choosenSortOption)
        }
    }
    
    init(service: CartService) {
        self.service = service
        if let savedSortOption = UserDefaults.standard.string(forKey: "SortOptionKey") {
            if let sortOption = SortOption(rawValue: savedSortOption) {
                self.choosenSortOption = sortOption
            }
        } else {
            self.choosenSortOption = SortOption.name
        }
    }
    
    func viewDidLoad() {
        state = .loading
    }
    
    func sortNFTs() {
        view?.sortOptions { [weak self] sortOption in
            self?.choosenSortOption = sortOption
            UserDefaults.standard.set(sortOption.rawValue, forKey: "SortOptionKey")
        }
    }

    func didTapCellDeleteButton(with id: String) {
        state = .delete
        idToDelete = id
    }
    
    func returnButtonTapped() {
        state = .data(nftsInCart)
    }
    
    func deleteButtonTapped() {
        nftsInCart.removeAll(where: {
            $0.id == idToDelete
        })
        state = nftsInCart.isEmpty ? .empty:.data(nftsInCart)
        service.removeFromCart(id: idToDelete, nfts: nftsInCart){_ in }
    }
    
    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can't move to inital state")
        case .loading:
            view?.showLoading()
            loadNfts()
        case .data(let nfts):
            view?.showDeleteWarning(show: false)
            view?.hideLoading()
            self.nftsInCart = nfts
            view?.setPrice(price: getTotalPrice(with: nfts))
            view?.setCount(count: getTotalCount(with: nfts))
            view?.enablePayButton()
            sort(with: .name)
        case .failed(let error):
            let errorModel = makeErrorModel(error)
            view?.hideLoading()
            view?.showError(errorModel)
            view?.showDeleteWarning(show: false)
        case .empty:
            view?.isCartEmpty()
            view?.showDeleteWarning(show: false)
        case .delete:
            view?.showDeleteWarning(show: true)
        }
    }
    
    private func loadNfts(){
        service.loadNfts(with: "1"){[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let nfts):
                if nfts.count > 0 {
                    self.state = .data(nfts)
                } else {
                    self.state = .empty
                }
            case .failure(let error):
                self.state = .failed(error)
            }
        }
    }
    
    private func makeErrorModel(_ error: Error) -> ErrorModel {
        let message: String
        switch error {
        case is NetworkClientError:
            message = NSLocalizedString("Error.network", comment: "")
        default:
            message = NSLocalizedString("Error.unknown", comment: "")
        }

        let actionText = NSLocalizedString("Error.repeat", comment: "")
        return ErrorModel(message: message, actionText: actionText) { [weak self] in
            self?.state = .loading
        }
    }
    
    private func sort(with sortOption: SortOption) {
        switch sortOption {
        case .price:
            nftsInCart = nftsInCart.sorted {$0.price < $1.price}
        case .rating:
            nftsInCart = nftsInCart.sorted {$0.rating > $1.rating}
        case .name:
            nftsInCart = nftsInCart.sorted {$0.name < $1.name}
        }
    }
    
    private lazy var priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }()
    
    private func formatPrice(_ price: Float) -> String? {
        return priceFormatter.string(from: NSNumber(value: price))
    }
    
    private func getTotalPrice(with nfts: [Nft]) -> String {
        var totalPrice: Float = 0.0
        nfts.forEach{
            totalPrice += $0.price
        }
        guard let totalString = formatPrice(totalPrice) else { return "0.0 ETH" }
        return totalString
    }
    
    private func getTotalCount(with nfts: [Nft]) -> Int {
        return nfts.count
    }
    
    func cleanCart() {
        var nftArray = [String]()
        nftsInCart.forEach { nft in
            if !nftArray.contains(nft.id) {
                nftArray.append(nft.id)
            }
        }
        service.removeFromCart(id: "1", nfts: []){_ in }
        state = .empty
    }
}
