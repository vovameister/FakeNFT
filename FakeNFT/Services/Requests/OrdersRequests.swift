//
//  OrdersRequest.swift
//  FakeNFT
//
//  Created by Ramilia on 04/02/24.
//

import Foundation

struct GetOrdersRequest: NetworkRequest {
    
    var httpMethod: HttpMethod { .get }
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
}

struct PutOrdersRequest: NetworkRequest {
    
    var id: String
    
    var orders: [String]
    
    var httpMethod: HttpMethod { .put }
    
    var body: Data? {
        return ordersToString().data(using: .utf8)
    }
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
    
    private func ordersToString() -> String {
        var orderString = "nfts="
        
        if orders.isEmpty {
            orderString = ""
        } else {
            for (index , nft) in orders.enumerated() {
                orderString += nft
                if index != orders.count - 1 {
                    orderString += "&nfts="
                }
            }
        }
        orderString += "&id=\(id)"
        return orderString
    }
}
