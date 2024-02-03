//
//  UserNftsService.swift
//  FakeNFT
//
//  Created by Ramilia on 03/02/24.
//

import Foundation

typealias UserNftCompletion = (Result<UserNft, Error>) -> Void

struct UserNftRequest: NetworkRequest {
    
    let id: String
    
    var httpMethod: HttpMethod { .get }
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(id)")
    }
}

// MARK: - Protocol
protocol UserNftServiceProtocol {
    func loadUserNft(with id: String, completion: @escaping UserNftCompletion)
}

final class UserNftService: UserNftServiceProtocol {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func loadUserNft(with id: String, completion: @escaping UserNftCompletion) {
        
        let request = UserNftRequest(id: id)
        
        networkClient.send(request: request, type: UserNft.self) { result in
            switch result {
            case .success(let nft):
                completion(.success(nft))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

