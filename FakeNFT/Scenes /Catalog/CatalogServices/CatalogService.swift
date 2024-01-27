//
//  CatalogService.swift
//  FakeNFT
//
//  Created by Artem Dubovitsky on 24.01.2024.
//
import Foundation

protocol CatalogServiceProtocol: AnyObject {
    func getNtfCollections(completion: @escaping (Result<[NFTCollection], Error>) -> Void)
}

final class CatalogService: CatalogServiceProtocol {
    // MARK: - Properties
    private let networkClient: DefaultNetworkClient
    // MARK: - Initializers
    init(networkClient: DefaultNetworkClient) {
        self.networkClient = networkClient
    }
    // MARK: - Get collections NFT
    func getNtfCollections(completion: @escaping (Result<[NFTCollection], Error>) -> Void) {
        let request = NFTCollectionsRequest()
        
        networkClient.send(request: request,
                           type: [NFTCollection].self) { result in
            switch result {
            case .success(let collections):
                completion(.success(collections))
            case .failure(let error):
                if let networkError = error as? NetworkClientError {
                    completion(.failure(networkError))
                } else {
                    completion(.failure(error))
                }
            }
        }
    }
}
