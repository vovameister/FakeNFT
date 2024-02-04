//
//  OredrsService.swift
//  FakeNFT
//
//  Created by Ramilia on 04/02/24.
//

import Foundation

typealias OrdersCompletion = (Result<Orders, Error>) -> Void

struct GetOrdersRequest: NetworkRequest {
    
    var httpMethod: HttpMethod { .get }
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
}

struct PutOrdersRequest: NetworkRequest {
    
    var orders: [String]
    
    var params: String {
        var params = ""
        orders.forEach {
            params += "nfts=" + $0 + "&"
        }
        params.removeLast()
        return params
    }
    
    var httpMethod: HttpMethod { .put }
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1?\(params)")
    }
}

// MARK: - Protocol
protocol OrdersServiceProtocol {
    func getOrders(completion: @escaping OrdersCompletion)
    func putOrders(orders: [String], completion: @escaping OrdersCompletion)
}

final class OrdersService: OrdersServiceProtocol {
    
    private let networkClient: NetworkClient
    
    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }
    
    func getOrders(completion: @escaping OrdersCompletion) {
        
        let request = GetOrdersRequest()
        
        networkClient.send(request: request, type: Orders.self) { result in
            switch result {
            case .success(let orders):
                completion(.success(orders))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func putOrders(orders: [String], completion: @escaping OrdersCompletion) {
        
        let request = PutOrdersRequest(orders: orders)
        
        networkClient.send(request: request, type: Orders.self) { result in
            switch result {
            case .success(let orders):
                completion(.success(orders))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

