//
//  UserInfoStorage.swift
//  FakeNFT
//
//  Created by Ramilia on 28/01/24.
//

import Foundation

protocol UserInfoStorageProtocol: AnyObject {
    func saveUserInfo(_ users: UserInfo)
}

final class UserInfoStorage: UserInfoStorageProtocol {
    
    private var storage: UserInfo?

    private let syncQueue = DispatchQueue(label: "sync-user-queue")
    
    func saveUserInfo(_ user: UserInfo) {
        syncQueue.async { [weak self] in
            self?.storage = user
        }
    }
}
