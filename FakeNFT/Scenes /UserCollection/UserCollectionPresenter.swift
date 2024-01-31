//
//  UserCollectionPresenter.swift
//  FakeNFT
//
//  Created by Ramilia on 30/01/24.
//

import Foundation

// MARK: - Protocol

protocol UserCollectionPresenterProtocol {
    func viewDidLoad()
}

final class UserCollectionPresenter: UserCollectionPresenterProtocol {
    
    // MARK: - Properties
    weak var view: UserCollectionViewProtocol?
    
    // MARK: - Init
    init() {
        print("init")
    }
    
    // MARK: - Functions
    func viewDidLoad() {
       // code
    }
}
