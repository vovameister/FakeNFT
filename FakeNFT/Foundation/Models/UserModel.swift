//
//  UserModel.swift
//  FakeNFT
//
//  Created by Ramilia on 21/01/24.
//

import Foundation

struct User: Codable {
    let id: String
    let name: String
    let avatar: URL?
    let nfts: [String]?
    let rating: String
    var ratingValue: Float { return Float(rating) ?? 0.0 }
}

struct UserCellModel {
    let id: String
    let name: String
    let avatar: URL?
    let nfts: [String]
    var ratingValue: Float
    var ratingPosition: Int
}
