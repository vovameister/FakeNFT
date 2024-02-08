//
//  NFTCellModel.swift
//  FakeNFT
//
//  Created by Artem Dubovitsky on 30.01.2024.
//
import Foundation

struct NFTCellModel {
    let id: String
    let name: String
    let image: URL?
    let rating: Int
    let isLiked: Bool
    let isInCart: Bool
    let price: Float
}
