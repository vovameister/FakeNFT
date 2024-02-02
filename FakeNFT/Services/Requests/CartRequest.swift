//
//  CartRequest.swift
//  FakeNFT
//
//  Created by Кира on 30.01.2024.
//

import Foundation

struct CartRequest: NetworkRequest {
    
    let id: String

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/\(id)")
    }
}

struct CartPutRequest: NetworkRequest {

    let id: String
    let nfts: [String]
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/\(id)")
    }
    
    var httpMethod: HttpMethod {
        .put
    }
    
    var dto: Encodable?{
        CartModel(nfts: nfts, id: id)
    }
}
