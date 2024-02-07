//
//  GetNFTRequest.swift
//  FakeNFT
//
//  Created by Владимир Клевцов on 6.2.24..
//

import Foundation

struct MyNFTRequest: NetworkRequest {
    var httpMethod: HttpMethod { .get }

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/nft")
    }
}
