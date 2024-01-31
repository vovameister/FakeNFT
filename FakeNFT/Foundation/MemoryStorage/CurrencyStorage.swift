//
//  CurrencyStorage.swift
//  FakeNFT
//
//  Created by Кира on 30.01.2024.
//

import Foundation

protocol CurrencyStorage: AnyObject {
    func saveCurrency(_ currency: [CurrencyModel])
    func getCurrency(with id: String) -> CurrencyModel?
}

// Пример простого класса, который сохраняет данные из сети
final class CurrencyStorageImpl: CurrencyStorage {
    private var storage: [String: CurrencyModel] = [:]

    private let syncQueue = DispatchQueue(label: "sync-nft-queue")

    func saveCurrency(_ currency: [CurrencyModel]) {
        syncQueue.async { [weak self] in
            currency.forEach{
                self?.storage[$0.id] = $0
            }
        }
    }

    func getCurrency(with id: String) -> CurrencyModel? {
        syncQueue.sync {
            storage[id]
        }
    }
}
