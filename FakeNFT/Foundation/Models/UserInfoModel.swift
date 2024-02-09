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
    let avatar: URL?
    let nfts: [String]?
    let description: String?
    let website: URL?
}

struct UserInfoModel {
    let id: String
    let name: String
    let avatar: URL?
    let nfts: [String]
    let description: String
    let website: URL?
    
    init(userInfo: UserInfo) {
        self.id = userInfo.id
        self.name = userInfo.name
        self.avatar = userInfo.avatar
        self.nfts = userInfo.nfts ?? []
        self.description = userInfo.description ?? ""
        self.website = userInfo.website
    }
}
