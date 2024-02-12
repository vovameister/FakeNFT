//
//  OrdersPutRequest.swift
//  FakeNFT
//
//  Created by Artem Dubovitsky on 05.02.2024.
//

import Foundation

struct OrdersPutRequest: NetworkRequest {
    let httpMethod: HttpMethod = .put
    var id: String
    var orders: Set<String>
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/1")
    }
    var body: Data? {
        return ordersToString().data(using: .utf8)
    }

    init(id: String, orders: Set<String>) {
        self.orders = orders
        self.id = id
    }

    func ordersToString() -> String {
        var ordersString = "nfts="

        if orders.isEmpty {
            ordersString += ""
        } else {
            for (index, order) in orders.enumerated() {
                ordersString += order
                if index != orders.count - 1 {
                    ordersString += "&nfts="
                }
            }
        }
        ordersString += "&id=\(id)"
        return ordersString
    }
}
