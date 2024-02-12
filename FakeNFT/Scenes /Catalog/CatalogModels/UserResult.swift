//
//  UserResult.swift
//  FakeNFT
//
//  Created by Artem Dubovitsky on 30.01.2024.
//

import Foundation

struct UserResult: Codable {
    let name: String
    let avatar: String
    let description: String
    let website: String
    let nfts: [String]
    let rating: String
    let id: String
}
