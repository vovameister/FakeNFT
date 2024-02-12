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
