//
//  UserInfoModel.swift
//  FakeNFT
//
//  Created by Ramilia on 28/01/24.
//

import Foundation

struct UserInfo: Codable {
    let id: String
    let name: String
    let avatar: URL
    let nfts: [String]
    let description: String
    let website: URL
}
