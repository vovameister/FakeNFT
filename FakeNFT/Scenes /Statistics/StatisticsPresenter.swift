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
    func showSortingMenu()
}

// MARK: - State

enum UsersState {
    case initial, loading, failed(Error), data([User])
}

final class StatisticsPresenter: StatisticsPresenterProtocol {
    
    // MARK: - Properties
    weak var view: StatisticsViewProtocol?
    
    private let userDefaults = UserDefaults.standard
    
    private var sorting: Sortings? {
        get {
            guard let sortingRawValue = userDefaults.string(forKey: "Statistics Sorting") else
            {
                return nil
            }
            return Sortings(rawValue: sortingRawValue)
        }
        set {
            userDefaults.set(newValue?.rawValue, forKey: "Statistics Sorting")
        }
    }
    
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
    
    func showSortingMenu() {
        let sortingMenu = makeSortingMenu()
        view?.showSortingMenu(sortingMenu)
    }
    
    private func makeSortingMenu() -> SortingModel {
        return SortingModel { [weak self] selectSorting in
            self?.setSorting(selectSorting)
        }
    }
    
    private func setSorting(_ selectSorting: Sortings?) {
        sorting = selectSorting
        state = .loading
    }
    
    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can't move to initial state")
        case .loading:
            view?.showLoadingAndBlockUI()
            loadUsers(with: sorting)
        case .data(let users):
            view?.hideLoadingAndUnblockUI()
            let cellModels = users
            view?.displayCells(cellModels)
        case .failed(let error):
            view?.hideLoadingAndUnblockUI()
            let errorModel = makeErrorModel(error)
            view?.showError(errorModel)
        }
    }
    
    private func loadUsers(with sorting: Sortings?) {
        service.loadUsers(with: sorting) { [weak self] result in
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
