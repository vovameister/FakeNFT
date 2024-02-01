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
}

enum CartDetailState {
    case initial, loading, failed(Error), data([Nft]), empty
}

final class CartViewPresenter: CartViewPresenterProtocol {
    weak var view: CartView?
    private let service: CartService
    private var state = CartDetailState.initial {
        didSet {
            stateDidChanged()
        }
    }
    
    init(service: CartService) {
        self.service = service
    }
    
    func viewDidLoad() {
        state = .loading
    }
    
    func sortNFTs() {
        
    }
    
    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can't move to inital state")
        case .loading:
            view?.showLoading()
            loadNfts()
        case .data(let nfts):
            view?.hideLoading()
            view?.setTableView(nfts: nfts)
        case .failed(let error):
            let errorModel = makeErrorModel(error)
            view?.hideLoading()
            view?.showError(errorModel)
        case .empty:
            view?.isCartEmpty()
        }
    }
    
    private func loadNfts(){
        service.loadNfts(with: "1"){[weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let nfts):
                self.state = .data(nfts)
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
    
}
