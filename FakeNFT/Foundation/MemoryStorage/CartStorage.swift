//
//  CartStorage.swift
//  FakeNFT
//
//  Created by Кира on 30.01.2024.
//

import Foundation

protocol CartStorage: AnyObject {
    func saveCart(_ currency: CartModel)
    func getCart(with id: String) -> CartModel?
}

// Пример простого класса, который сохраняет данные из сети
final class CartStorageImpl: CartStorage {
    private var storage: [String: CartModel] = [:]

    private let syncQueue = DispatchQueue(label: "sync-nft-queue")

    func saveCart(_ cart: CartModel) {
        syncQueue.async { [weak self] in
            self?.storage[cart.id] = cart
        }
    }

    func getCart(with id: String) -> CartModel? {
        syncQueue.sync {
            storage[id]
        }
    }
}
