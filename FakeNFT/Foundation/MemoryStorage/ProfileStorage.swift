//
//  ProfileStorage.swift
//  FakeNFT
//
//  Created by Владимир Клевцов on 31.1.24..
//

import Foundation

protocol ProfileStorageProtocol: AnyObject {
    func saveProfile(profile: Profile)
    func getProfile() -> Profile?
}

final class ProfileStorage: ProfileStorageProtocol {
    static let shared = ProfileStorage()

    private var storage: Profile?

    private let syncQueue = DispatchQueue(label: "sync-user-queue")

    func saveProfile(profile: Profile) {
        syncQueue.async { [weak self] in
            self?.storage = profile
        }
    }
    func getProfile() -> Profile? {
        syncQueue.sync {
            storage
        }
    }
}
