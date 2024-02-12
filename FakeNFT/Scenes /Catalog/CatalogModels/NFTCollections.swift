//
//  NFTCollections.swift
//  FakeNFT
//
//  Created by Artem Dubovitsky on 24.01.2024.
//
import Foundation

struct NFTCollection: Codable {
    let createdAt: String
    let name: String
    let cover: String
    let nfts: [String]
    let description: String
    let author: String
    let id: String
}
