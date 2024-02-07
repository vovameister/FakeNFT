//
//  ProfileService2.swift
//  FakeNFT
//
//  Created by Владимир Клевцов on 31.1.24..
//

import Foundation

typealias ProfileCompletion = (Result<Profile, Error>) -> Void

protocol PropfileServiceProtocol {
    func loadProfile(completion: @escaping ProfileCompletion)
}
protocol EditProfileServiceProtocol {
    func loadProfile(completion: @escaping ProfileCompletion)
    func putProfile(name: String,
                    description: String,
                    website: String,
                    completion: @escaping ProfileCompletion)
    var newAvatarURL: String? { get set }
}

final class ProfileService: PropfileServiceProtocol, EditProfileServiceProtocol {
    static let shared = ProfileService(networkClient: DefaultNetworkClient(), storage: ProfileStorage.shared)

    private let networkClient: NetworkClient
    private let storage: ProfileStorageProtocol

    var oldAvatarURL: String?
    var newAvatarURL: String?

    init(networkClient: NetworkClient, storage: ProfileStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }

    func loadProfile(completion: @escaping ProfileCompletion) {
        if let profile = storage.getProfile() {
            completion(.success(profile))
            return
        }
        let request = ProfileRequest()
        networkClient.send(request: request, type: Profile.self) { [weak storage] result in
            switch result {
            case .success(let profile):
                storage?.saveProfile(profile: profile)
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    func putProfile(name: String, description: String, website: String, completion: @escaping ProfileCompletion) {
        let request = ProfilePutRequest(name: name,
                                        description: description,
                                        website: website,
                                        likes: storage.getProfile()?.likes ?? []
        )
        networkClient.send(request: request, type: Profile.self) { [weak storage] result in
            switch result {
            case .success(let profile):
                storage?.saveProfile(profile: profile)
                completion(.success(profile))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    func saveAvater() {
        if newAvatarURL != nil {
            UserDefaults.standard.set(newAvatarURL, forKey: "userURL")
            oldAvatarURL = newAvatarURL
        }
    }
}
