//
//  MyNFTService.swift
//  FakeNFT
//
//  Created by Владимир Клевцов on 26.1.24..
//

import Foundation

final class MyNFTService {
    static let shared = MyNFTService()

    var myNFTs: [MyNFT] = []
    var likedNFTsid: [Int] = []
    var likedNFT: [MyNFT] = []

    init() {
        myNFTs = mockNFTs
    }

    let mockNFTs: [MyNFT] = [
        MyNFT(id: 1, image: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/1.png",
              name: "CNpapapap",
              rating: 4,
              author: "Artist1",
              price: 10.99),
        MyNFT(id: 2, image: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/2.png",
              name: "Awolpda",
              rating: 5,
              author: "Artist2",
              price: 19.99),
        MyNFT(id: 3, image: "https://code.s3.yandex.net/Mobile/iOS/NFT/Beige/April/1.png",
              name: "BXDqpls",
              rating: 3,
              author: "Artist3",
              price: 15.49)
    ]

    func sortByPrice() {
        myNFTs = myNFTs.sorted { $0.price > $1.price }
    }
    func sortByRating() {
        myNFTs = myNFTs.sorted { $0.rating > $1.rating }
    }
    func sortByName() {
        myNFTs = myNFTs.sorted { $0.name.localizedCompare($1.name) == .orderedAscending }
    }
    func containsInt(value: Int) -> Bool {
        return likedNFTsid.contains(value)
    }

    func updateLikedNFT() {
        likedNFT = myNFTs.filter { likedNFTsid.contains($0.id) }
    }
    func mapNFTId(for nftName: String) -> Int? {
           return likedNFT.first { $0.name == nftName }?.id
       }
}
