//
//  StatisticsService.swift
//  FakeNFT
//
//  Created by Ramilia on 21/01/24.
//

import Foundation

typealias UsersCompletion = (Result<[User], Error>) -> Void

struct UsersRequest: NetworkRequest {
    
    var httpMethod: HttpMethod { .get }
    
    var sortingParam = ""
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/users" + sortingParam)
    }
}

// MARK: - Protocol
protocol UsersServiceProtocol {
    func loadUsers(with sorting: Sortings?, completion: @escaping UsersCompletion)
}

final class UsersService: UsersServiceProtocol {
    
    private let storage: UsersStorage
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient, storage: UsersStorage) {
        self.storage = storage
        self.networkClient = networkClient
    }
    
    func loadUsers(with sorting: Sortings?, completion: @escaping UsersCompletion) {
        
        var request = UsersRequest()
        
        switch sorting {
        case .byName:
            request.sortingParam = "?sortBy=name&order=asc"
        case .byRating:
            request.sortingParam = "?sortBy=rating&order=desc"
        case .none:
            request.sortingParam = ""
        }
        
        networkClient.send(request: request, type: [User].self) { [weak storage] result in
            switch result {
            case .success(let users):
                storage?.saveUsers(users)
                completion(.success(users))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
