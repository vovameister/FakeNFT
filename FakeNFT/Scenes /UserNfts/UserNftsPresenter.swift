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
    
    private let nftsInput: [String]
    private let service: UserNftServiceProtocol
    
    private var state = UserNftsState.initial {
        didSet {
            stateDidChanged()
        }
    }
    
    // MARK: - Init
    init(nftsInput: [String], service: UserNftServiceProtocol) {
        self.nftsInput = nftsInput
        self.service = service
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
        nftsInput.forEach {
            service.loadUserNft(with: $0, completion: { [weak self] result in
                guard let self = self else {
                    return
                }
                switch result {
                case .success(let nft):
                    let nftCell = convertToNftCellModel(from: nft)
                    self.userNfts.append(nftCell)
                    if nftsInput.count == self.userNfts.count {
                        state = .data
                    }
                case .failure(let error):
                    state = .failed(error)
                }
            })
        }
    }
    
    private func convertToNftCellModel(from nft: UserNft) -> UserNftCellModel {
        let cell = UserNftCellModel(
            id: nft.id,
            name: nft.name,
            image: nft.images.first,
            price: String(nft.price),
            rating: Int(nft.rating) ?? 0
        )
        return cell
    }
}
