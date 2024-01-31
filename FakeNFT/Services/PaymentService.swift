//
//  PaymentService.swift
//  FakeNFT
//
//  Created by Кира on 30.01.2024.
//

import Foundation

protocol PaymentServiceProtocol {
    func loadCurrencies(completion: @escaping (Result<[CurrencyModel], Error>) -> Void)
}

final class PaymentService: PaymentServiceProtocol {
    private let networkClient: NetworkClient
    private let storage: CurrencyStorage
    
    init(networkClient: NetworkClient, storage: CurrencyStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }
    
    func loadCurrencies(completion: @escaping (Result<[CurrencyModel], Error>) -> Void) {
        let request = CurrencyRequest()
        networkClient.send(request: request, type: [CurrencyModel].self) { [weak self] result in
            switch result {
            case .success(let currencies):
                self?.storage.saveCurrency(currencies)
                completion(.success(currencies))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
