//
//  CatalogStorage.swift
//  FakeNFT
//
//  Created by Artem Dubovitsky on 04.02.2024.
//
import Foundation

protocol CatalogStorageProtocol: AnyObject {
    var likes: Set<String> { get set }
    func saveNft(_ nft: String)
    func getNft(with id: String) -> String?
}

final class CatalogStorage: CatalogStorageProtocol {
    var likes: Set<String> = []
    private let syncQueue = DispatchQueue(label: "sync-nft-queue")

    func saveNft(_ nft: String) {
        syncQueue.async { [weak self] in
            self?.likes.insert(nft)
        }
    }
    
    func getNft(with id: String) -> String? {
        syncQueue.sync {
            likes.first(where: { $0 == id })
        }
    }
}
