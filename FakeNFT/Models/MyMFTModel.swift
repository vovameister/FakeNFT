//
//  MyMFTModel.swift
//  FakeNFT
//
//  Created by Владимир Клевцов on 23.1.24..
//

import Foundation

struct MyNFT: Decodable {
    let images: [String]
    let name: String
    let rating: Int
    let author: String
    let price: Float
    let id: String
}
