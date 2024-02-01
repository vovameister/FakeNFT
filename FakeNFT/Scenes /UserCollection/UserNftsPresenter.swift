//
//  UserNftsPresenter.swift
//  FakeNFT
//
//  Created by Ramilia on 30/01/24.
//

import Foundation

// MARK: - Protocol

protocol UserNftsPresenterProtocol {
    var userNfts: [UserNftCellModel] { get set }
    func viewDidLoad()
}

// MARK: - State

enum UserNftsState {
    case initial, loading, data, failed(Error)
}

final class UserNftsPresenter: UserNftsPresenterProtocol {
    
    // MARK: - Properties
    weak var view: UserNftsViewProtocol?
    var userNfts = [UserNftCellModel]()
    
    private var state = UserNftsState.initial {
        didSet {
            stateDidChanged()
        }
    }
    
    // MARK: - Init
    init() {
        print("init")
    }
    
    // MARK: - Functions
    func viewDidLoad() {
        state = .loading
    }
    
    private func mockData() {
        let url1 = URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/1.png")
        let url2 = URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Breena/1.png")
        let url3 = URL(string: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/Buster/1.png")
        let url4 = URL(string: "")
        
        userNfts = [
            UserNftCellModel(id: "1", name: "Archie", image: url1, price: "1.35", rating: 1),
            UserNftCellModel(id: "2", name: "Emma", image: url2, price: "2.70", rating: 5),
            UserNftCellModel(id: "3", name: "Buster 123456789012334", image: url3, price: "5.0", rating: 0),
            UserNftCellModel(id: "4", name: "Cupid", image: url4, price: "2", rating: 2)
        ]
        
        for index in 5...20 {
            let user =  UserNftCellModel(id: "\(index)", name: "Archie", image: url1, price: "1.35", rating: 3)
            userNfts.append(user)
        }
    }
    
    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can't move to initial state")
        case .loading:
            loadUserNfts()
        case .data:
            view?.displayUserNfts()
        case .failed(_):
            print("error")
        }
    }
    
    private func loadUserNfts() {
        mockData()
        state = .data
    }
}
