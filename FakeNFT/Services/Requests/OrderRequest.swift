//
//  OrderRequest.swift
//  FakeNFT
//
//  Created by Кира on 02.02.2024.
//

import Foundation

struct OrderRequest: NetworkRequest {
    let id: String
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1/payment/\(id)")
    }
}
