//
//  CatalogService.swift
//  FakeNFT
//
//  Created by Artem Dubovitsky on 24.01.2024.
//
import Foundation

protocol CatalogServiceProtocol: AnyObject {
    func getAuthorNftCollection(id: String, completion: @escaping (UserModel) -> Void)
    func getNtfCollections(completion: @escaping (Result<[NFTCollection], Error>) -> Void)
    func getNFTs(id: String, completion: @escaping (Result<NFTs, Error>) -> Void)
}

final class CatalogService: CatalogServiceProtocol {
    
    // MARK: - Properties
    private let networkClient: DefaultNetworkClient
    // MARK: - Initializers
    init(networkClient: DefaultNetworkClient) {
        self.networkClient = networkClient
    }
    // MARK: - Get Author Nft Collection
    func getAuthorNftCollection(id: String, completion: @escaping (UserModel) -> Void) {
        let request = UserRequest(id: id)
        networkClient.send(request: request,
                           type: UserResult.self) { result in
            switch result {
            case .success(let data):
                completion((UserModel(with: data)))
            case .failure(let error):
                print(error)
            }
        }
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
    // MARK: - Get NFTs
    func getNFTs(id: String, completion: @escaping (Result<NFTs, Error>) -> Void) {
        let request = NFTRequest(id: id)
        networkClient.send(request: request,
                           type: NFTs.self) { result in
            switch result {
            case .success(let nft):
                completion(.success(nft))
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
