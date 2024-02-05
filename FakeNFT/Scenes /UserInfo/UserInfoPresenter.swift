//
//  UserInfoPresenter.swift
//  FakeNFT
//
//  Created by Ramilia on 26/01/24.
//

import Foundation

// MARK: - Protocol

protocol UserInfoPresenterProtocol {
    var user: UserInfo? { get set }
    func viewDidLoad()
    func getNftsStringArray() -> [String] 
}

// MARK: - State

enum UserInfoState {
    case initial, loading, data(UserInfo), failed(Error)
}

final class UserInfoPresenter: UserInfoPresenterProtocol {
    
    // MARK: - Properties
    weak var view: UserInfoViewProtocol?
    var user: UserInfo?
    
    private let userID: String
    private let service: UserInfoServiceProtocol
    private var state = UserInfoState.initial {
        didSet {
            stateDidChanged()
        }
    }
    
    // MARK: - Init
    init(userID: String, service: UserInfoServiceProtocol) {
        self.userID = userID
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
            view?.showLoadingAndBlockUI()
            loadUserInfo()
        case .data(let user):
            view?.hideLoadingAndUnblockUI()
            self.user = user
            view?.displayUserInfo(with: user)
        case .failed(let error):
            view?.hideLoadingAndUnblockUI()
            let errorModel = makeErrorModel(error)
            view?.showError(errorModel)
        }
    }
    
    private func loadUserInfo() {
        service.loadUserInfo(with: userID) { [weak self] result in
            switch result {
            case .success(let user):
                self?.state = .data(user)
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
    
    func getNftsStringArray() -> [String] {
        guard let user = user else {
            return []
        }
        //для дебага
//        let nfts = [
//            "256e28df-aa17-46e4-9586-cb78aab7143c",
//            "5cd791a3-96cd-4ac3-92cd-744f7422fb31",
//            "04b79f11-313e-47b4-bd26-f513b77ed264",
//            "b2f44171-7dcd-46d7-a6d3-e2109aacf520",
//            "739e293c-1067-43e5-8f1d-4377e744ddde",
//            "8763e529-ab5f-410f-95c8-d08cb6f49453",
//            "34c50a1f-e66b-4617-b7a9-8307bb0769af"
//        ]
        return user.nfts
    }
}
