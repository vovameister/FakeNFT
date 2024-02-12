//
//  OrdersRequest.swift
//  FakeNFT
//
//  Created by Artem Dubovitsky on 05.02.2024.
//
import Foundation

struct OrdersRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
}
