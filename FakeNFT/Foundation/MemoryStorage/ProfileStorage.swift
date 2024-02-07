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
protocol LikeStorageProtocol: AnyObject {
    func getLikes() -> [String]
    func updateLikes(likes: [String])
}
final class ProfileStorage: ProfileStorageProtocol, LikeStorageProtocol {
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
    func getLikes() -> [String] {
        syncQueue.sync {
            storage?.likes ?? []
        }
    }
    func updateLikes(likes: [String]) {
        storage?.likes = likes
    }
}