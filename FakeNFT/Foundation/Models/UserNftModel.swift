//
//  UserNftModel.swift
//  FakeNFT
//
//  Created by Ramilia on 31/01/24.
//

import Foundation

struct UserNft: Codable {
    let id: String
    let name: String
    let images: [URL]
    let price: Float
    let rating: Int
}

struct UserNftCellModel {
    let id: String
    let name: String
    let image: URL?
    let price: String
    let rating: Int
    var like: Bool
    var order: Bool
    
    mutating func changeLike() {
        like.toggle()
    }
    
    mutating func changeOrder() {
        order.toggle()
    }
}
