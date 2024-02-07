//
//  ProfileModel.swift
//  FakeNFT
//
//  Created by Владимир Клевцов on 31.1.24..
//

import Foundation

struct Profile: Decodable {
    let name: String
    let avatar: String?
    let description: String?
    let website: String?
    let nfts: [String]?
    let id: String
    var likes: [String]?
}
