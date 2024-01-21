//
//  StatisticsPresenter.swift
//  FakeNFT
//
//  Created by Ramilia on 21/01/24.
//

import Foundation

// MARK: - Protocol

protocol StatisticsPresenterProtocol {
    func viewDidLoad()
}

// MARK: - State

enum UsersState {
    case initial, loading, failed(Error), data([User])
}

final class StatisticsPresenter: StatisticsPresenterProtocol {
    
    // MARK: - Properties
    weak var view: StatisticsViewProtocol?
    private let service: UsersServiceProtocol
    private var state = UsersState.initial {
        didSet {
            stateDidChanged()
        }
    }

    // MARK: - Init

    init(service: UsersServiceProtocol) {
        self.service = service
    }

    // MARK: - Functions

    func viewDidLoad() {
        state = .loading
    }

    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can't move to initial state")
        case .loading:
            loadUsers()
        case .data(let users):
            let cellModels = users
            view?.displayCells(cellModels)
        case .failed(let error):
            let errorModel = makeErrorModel(error)
            view?.showError(errorModel)
        }
    }

    private func loadUsers() {
        service.loadUsers { [weak self] result in
            switch result {
            case .success(let users):
                self?.state = .data(users)
            case .failure(let error):
                self?.state = .failed(error)
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
