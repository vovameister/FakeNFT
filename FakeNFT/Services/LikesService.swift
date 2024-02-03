//
//  GetLikesService.swift
//  FakeNFT
//
//  Created by Ramilia on 03/02/24.
//

import Foundation

typealias LikesCompletion = (Result<Likes, Error>) -> Void

struct GetLikesRequest: NetworkRequest {
    
    var httpMethod: HttpMethod { .get }
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
}

struct PutLikesRequest: NetworkRequest {
    
    var likes: [String]
    
    var params: String {
        var params = ""
        likes.forEach {
            params += "likes=" + $0 + "&"
        }
        params.removeLast()
        return params
    }
    
    var httpMethod: HttpMethod { .put }
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1?\(params)")
    }
}

// MARK: - Protocol
protocol LikesServiceProtocol {
    func getLikes(completion: @escaping LikesCompletion)
    func putLikes(likes: [String], completion: @escaping LikesCompletion)
}

final class LikesService: LikesServiceProtocol {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func getLikes(completion: @escaping LikesCompletion) {
        
        let request = GetLikesRequest()
        
        networkClient.send(request: request, type: Likes.self) { result in
            switch result {
            case .success(let likes):
                completion(.success(likes))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func putLikes(likes: [String], completion: @escaping LikesCompletion) {
        
        let request = PutLikesRequest(likes: likes)

        networkClient.send(request: request, type: Likes.self) { result in
            switch result {
            case .success(let likes):
                completion(.success(likes))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
