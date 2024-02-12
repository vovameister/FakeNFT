//
//  UserModel.swift
//  FakeNFT
//
//  Created by Artem Dubovitsky on 30.01.2024.
//
import Foundation

struct UserModel {
    let id: String
    let name: String
    let website: String

    init(with user: UserResult) {
        self.id = user.id
        self.name = user.name
        self.website = user.website
    }
}
