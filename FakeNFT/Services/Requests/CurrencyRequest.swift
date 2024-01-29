//
//  CurrenciesRequest.swift
//  FakeNFT
//
//  Created by Кира on 30.01.2024.
//

import Foundation

struct CurrencyRequest: NetworkRequest {

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/currencies")
    }
}
