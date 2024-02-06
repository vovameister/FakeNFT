//
//  PaymentViewPresenter.swift
//  FakeNFT
//
//  Created by Кира on 29.01.2024.
//

import UIKit

protocol PaymentViewPresenterProtocol {
    func viewDidLoad()
    func didTapPayButton()
}

enum PaymentError: Error {
    case failedPayment
}

enum PaymentDetailState {
    case initial, loading, failed(Error), data([CurrencyModel])
}

final class PaymentViewPresenter: PaymentViewPresenterProtocol {
    
    weak var view: PaymentView?
    private let service: PaymentService
    private var state = PaymentDetailState.initial {
        didSet {
            stateDidChanged()
        }
    }
    
    init(service: PaymentService) {
        self.service = service
    }
    
    func viewDidLoad() {
        state = .loading
    }
    
    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can't move to inital state")
        case .loading:
            view?.showLoading()
            loadCurrencies()
        case .data(let currencies):
            view?.hideLoading()
            view?.setCollectionView(currencies: currencies)
        case .failed(let error):
            let errorModel = makeErrorModel(error)
            view?.hideLoading()
            view?.showError(errorModel)
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
    
    func loadCurrencies(){
        service.loadCurrencies{ [weak self] result in
            guard let self = self else { return }
            switch result{
            case .success(let currencies):
                self.state = .data(currencies)
            case .failure(let error):
                self.state = .failed(error)
            }
        }
    }
    
    func didTapPayButton() {
        service.getPaymentResult(with: "1" ){ [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let paymentResult):
                if paymentResult.success {
                    view?.showPaymentResultView()
                } else {
                    let errorModel = makeErrorModel(PaymentError.failedPayment)
                    view?.showError(errorModel)
                }
            case .failure(let error):
                self.state = .failed(error)
            }
        }
    }
}
