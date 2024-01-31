//
//  NFTs.swift
//  FakeNFT
//
//  Created by Artem Dubovitsky on 30.01.2024.
//
import Foundation

struct NFTs: Decodable {
    let createdAt: String
    let name: String
    let images: [URL]
    let rating: Int
    let description: String
    let price: Float
    let author: String
    let id: String
}
