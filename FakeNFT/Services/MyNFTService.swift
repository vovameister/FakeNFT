//
//  MyNFTService.swift
//  FakeNFT
//
//  Created by Владимир Клевцов on 26.1.24..
//

import Foundation
typealias LikesCompletion = (Result<Likes, Error>) -> Void
typealias MyNFTCompletion = (Result<[MyNFT], Error>) -> Void

protocol MyNFTServiceProtocol {
    func loadNFT(completion: @escaping MyNFTCompletion)
    func putLikes(likes: [String], completion: @escaping LikesCompletion)
}

final class MyNFTService: MyNFTServiceProtocol {
    static let shared = MyNFTService(networkClient: DefaultNetworkClient())

    private let networkClient: NetworkClient
    private let likeStorage: LikeStorageProtocol

    var myNFTs: [MyNFT] = []
    var likedNFTsid: [String] = []
    var likedNFT: [MyNFT] = []

    let defaults = UserDefaults.standard
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
        self.likeStorage = ProfileStorage.shared
        savedSortBy(tipe: defaults.integer(forKey: "savedFilter"))
    }

    private func savedSortBy(tipe: Int) {
        if tipe == 0 {
            sortByRating()
        } else if tipe == 1 {
            sortByPrice()
        } else {
            sortByName()
        }
    }

    func sortByPrice() {
        myNFTs = myNFTs.sorted { $0.price > $1.price }
        defaults.set(1, forKey: "savedFilter")
    }
    func sortByRating() {
        myNFTs = myNFTs.sorted { $0.rating > $1.rating }
        defaults.set(0, forKey: "savedFilter")
    }
    func sortByName() {
        myNFTs = myNFTs.sorted { $0.name.localizedCompare($1.name) == .orderedAscending }
        defaults.set(2, forKey: "savedFilter")
    }
    func contains(value: String) -> Bool {
        return likedNFTsid.contains(value)
    }

    func updateLikedNFT() {
        likedNFT = myNFTs.filter { likedNFTsid.contains($0.id) }
    }
    func mapNFTId(for nftName: String) -> String? {
        return likedNFT.first { $0.name == nftName }?.id
    }

    func loadNFT(completion: @escaping MyNFTCompletion) {
        if myNFTs.count > 0 {
            completion(.success(myNFTs))
            return
        }
        UIBlockingProgressHUD.show()
        let request = MyNFTRequest()
        networkClient.send(request: request, type: [MyNFT].self) { [weak self] result in
            switch result {
            case .success(let NFTs):
                self?.myNFTs = NFTs
                UIBlockingProgressHUD.dismiss()
                completion(.success(NFTs))
            case .failure(let error):
                UIBlockingProgressHUD.dismiss()
                completion(.failure(error))
            }
        }
    }
    func updateLikesFirstTime() {
        likedNFTsid = likeStorage.getLikes()
        updateLikedNFT()
    }
    func putLikes(likes: [String], completion: @escaping LikesCompletion) {

        let request = PutLikesRequest(likes: likes)

        networkClient.send(request: request, type: Likes.self) { result in
            switch result {
            case .success(let like):
                self.likeStorage.updateLikes(likes: likes)
                completion(.success(like))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
