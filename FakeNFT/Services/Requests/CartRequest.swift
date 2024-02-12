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
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
    
    var httpMethod: HttpMethod {
        .put
    }
    
    var dto: Encodable?
    var body: Data?
    init(id: String, nfts: [String]) {
        var nftsToPUT = ""
        nfts.enumerated().forEach {  (index, nft) in
            nftsToPUT += "nfts=\(nft)&"
        }
        nftsToPUT += "id=\(id)"
        self.body = nftsToPUT.data(using: .utf8)
//        self.dto = CartModel(nfts: nfts, id: id)
    }
}
