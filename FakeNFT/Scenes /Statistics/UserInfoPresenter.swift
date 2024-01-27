//
//  UserInfoPresenter.swift
//  FakeNFT
//
//  Created by Ramilia on 26/01/24.
//

import Foundation

// MARK: - Protocol

protocol UserInfoPresenterProtocol {
    func viewDidLoad()
}

// MARK: - State

enum UserInfoState {
    case initial, loading, data(User), update, failed(Error)
}

final class UserInfoPresenter: UserInfoPresenterProtocol {
    
    // MARK: - Properties
    weak var view: UserInfoViewProtocol?
    private let userID: String
    
    // MARK: - Init
    init(userID: String) {
        self.userID = userID
        print(self.userID)
        //self.service = service
    }
    
    // MARK: - Functions
    func viewDidLoad() {
       //code
    }
}
