//
//  MyNFTService.swift
//  FakeNFT
//
//  Created by Владимир Клевцов on 26.1.24..
//

import Foundation
typealias LikesCompletion = (Result<Likes, Error>) -> Void
typealias MyNFTCompletion = (Result<MyNFT, Error>) -> Void

final class MyNFTService {

    static let shared = MyNFTService(networkClient: DefaultNetworkClient())

    private let networkClient: NetworkClient
    private let storage: MyNFTStorageProtocol

    var myNFTs: [MyNFT] = []
    var myNFTsID: [String] = []
    var likedNFTsid: [String] = []
    var likedNFT: [MyNFT] = []

    let defaults = UserDefaults.standard
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
        self.storage = ProfileStorage.shared
        self.updateFirstTime()
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
    func loadLikedNFT(completion: @escaping () -> Void) {
        if likedNFTsid.count == 0 {
            completion()
            return
        }
        if likedNFT.count > 0 {
            completion()
            return
        }
        var remainingCount = likedNFTsid.count
        for id in likedNFTsid {
            loadNft(id: id) { result in
                switch result {
                case .success(let nft):
                    self.likedNFT.append(nft)
                    print("Successfully loaded NFT: \(nft)")
                case .failure(let error):
                    print("Error loading NFT: \(error)")
                }
                remainingCount -= 1
                if remainingCount == 0 {
                    completion()
                }
            }
        }
    }

    func loadMyNFT(completion: @escaping () -> Void) {
        if myNFTsID.count == 0 {
            completion()
            return
        }
        if myNFTs.count > 0 {
            completion()
            return
        }
        var remainingCount = myNFTsID.count
        for id in myNFTsID {
            loadNft(id: id) { result in
                switch result {
                case .success(let nft):
                    self.myNFTs.append(nft)
                    print("Successfully loaded NFT: \(nft)")
                case .failure(let error):
                    print("Error loading NFT: \(error)")
                }
                remainingCount -= 1
                if remainingCount == 0 {
                    completion()
                    self.savedSortBy(tipe: self.defaults.integer(forKey: "savedFilter"))
                }
            }
        }
    }

    func loadNft(id: String, completion: @escaping MyNFTCompletion) {
        let request = NFTRequest(id: id)
        networkClient.send(request: request, type: MyNFT.self) { result in
            switch result {
            case .success(let nft):
                completion(.success(nft))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func updateFirstTime() {
        likedNFTsid = storage.getLikes()
        myNFTsID = storage.getNFTs()
    }
    func updateLikedNFT() {
        likedNFT = likedNFT.filter { likedNFTsid.contains($0.id) } +
        myNFTs.filter { likedNFTsid.contains($0.id) }
        likedNFT = removeDuplicatesByID(likedNFT)
    }
    func removeDuplicatesByID(_ nfts: [MyNFT]) -> [MyNFT] {
        var uniqueNFTs = [String: MyNFT]()

        for nft in nfts {
            uniqueNFTs[nft.id] = nft
        }

        return Array(uniqueNFTs.values)
    }
    func putLikes(likes: [String], completion: @escaping LikesCompletion) {

        let request = PutLikesRequest(likes: likes)

        networkClient.send(request: request, type: Likes.self) { result in
            switch result {
            case .success(let like):
                self.storage.updateLikes(likes: likes)
                completion(.success(like))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    func mapNFTId(for nftName: String) -> String? {
        return likedNFT.first { $0.name == nftName }?.id
    }
}
