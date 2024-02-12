//
//  LikeModel.swift
//  FakeNFT
//
//  Created by Ramilia on 03/02/24.
//

import Foundation

struct Likes: Codable {
    let likes: [String]
}

struct Orders: Codable {
    var nfts: [String]
    let id: String

    init() {
        self.id = ""
        self.nfts = []
    }
}
