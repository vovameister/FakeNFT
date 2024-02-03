//
//  UserNftsPresenter.swift
//  FakeNFT
//
//  Created by Ramilia on 30/01/24.
//

import Foundation

// MARK: - Protocol

protocol UserNftsPresenterProtocol {
    var userNftsCellModel: [UserNftCellModel] { get set }
    func viewDidLoad()
    func updateLike(_ cell: UserNftCell, index: Int)
}

// MARK: - State

enum UserNftsState {
    case initial, loading, data, failed(Error)
}

final class UserNftsPresenter: UserNftsPresenterProtocol {
    
    // MARK: - Properties
    weak var view: UserNftsViewProtocol?
    var userNftsCellModel = [UserNftCellModel]()
    var likesProfile = [String]()
    
    private let nftService: UserNftServiceProtocol
    private let likeService: LikesServiceProtocol
    private let nftsInput: [String]
    private var userNfts = [UserNft]()

    private var state = UserNftsState.initial {
        didSet {
            stateDidChanged()
        }
    }
    
    // MARK: - Init
    init(nftsInput: [String], nftService: UserNftServiceProtocol, likeService: LikesServiceProtocol) {
        self.nftsInput = nftsInput
        self.nftService = nftService
        self.likeService = likeService
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
        
        userNftsCellModel = [
            UserNftCellModel(id: "a640ea4f-fe73-4994-835a-a715542cdaeb", name: "Archie", image: url1, price: "1.35", rating: 1, like: false),
            UserNftCellModel(id: "2", name: "Emma", image: url2, price: "2.70", rating: 5, like: false),
            UserNftCellModel(id: "3", name: "Buster 123456789012334", image: url3, price: "5.0", rating: 0, like: false),
            UserNftCellModel(id: "4", name: "Cupid", image: url4, price: "2", rating: 2, like: false)
        ]
        
        for index in 5...10 {
            let user =  UserNftCellModel(id: "\(index)", name: "Archie", image: url1, price: "1.35", rating: 3, like: false)
            userNftsCellModel.append(user)
        }
        
        state = .data
    }
    
    private func stateDidChanged() {
        switch state {
        case .initial:
            assertionFailure("can't move to initial state")
        case .loading:
            view?.showLoadingAndBlockUI()
            loadLikesProfile()
            loadUserNfts()
        case .data:
            view?.hideLoadingAndUnblockUI()
            setLikes()
            view?.displayUserNfts()
        case .failed(let error):
            view?.hideLoadingAndUnblockUI()
            let errorModel = makeErrorModel(error)
            view?.showError(errorModel)
        }
    }
    
    private func loadUserNfts() {
        nftService.loadNfts(with: nftsInput, completion: { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let nfts):
                self.userNfts = nfts
                if nftsInput.count == self.userNfts.count {
                    state = .data
                }
            case .failure(let error):
                state = .failed(error)
            }
        })
    }
    
    private func loadLikesProfile() {
        likeService.getLikes (completion: { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let likes):
                self.likesProfile = likes.likes
            case .failure(let error):
                self.state = .failed(error)
            }
        })
    }
    
    private func convertToNftCellModel(from nft: UserNft, like: Bool) -> UserNftCellModel {
        let cell = UserNftCellModel(
            id: nft.id,
            name: nft.name,
            image: nft.images.first,
            price: String(nft.price),
            rating: nft.rating,
            like: like
        )
        return cell
    }
    
    private func setLikes(){
        for nft in userNfts {
            let like = likesProfile.first { like in
                return like == nft.id
            } != nil
            let nftCell = convertToNftCellModel(from: nft, like: like)
            userNftsCellModel.append(nftCell)
        }
    }
    
    func updateLike(_ cell: UserNftCell, index: Int) {
        userNftsCellModel[index].changeLike()
        let nft = userNftsCellModel[index]
        updateLikes(to: cell, by: nft.like, nftId: nft.id)
    }
    
    private func updateLikes(to cell: UserNftCell, by like: Bool, nftId: String) {
        switch like {
        case true:
            likesProfile.append(nftId)
        case false:
            likesProfile.removeAll(where: {
                $0 == nftId
            })
        }
        putLikes(cell: cell, like: like)
    }
    
    private func putLikes(cell: UserNftCell, like: Bool) {
        likeService.putLikes(likes: likesProfile) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let likes):
                self.likesProfile = likes.likes
                cell.setLike(to: like)
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
