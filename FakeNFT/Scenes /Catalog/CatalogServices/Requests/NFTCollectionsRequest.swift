//
//  NFTCollectionsRequest.swift
//  FakeNFT
//
//  Created by Artem Dubovitsky on 24.01.2024.
//
import Foundation

struct NFTCollectionsRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/collections")
    }
}
