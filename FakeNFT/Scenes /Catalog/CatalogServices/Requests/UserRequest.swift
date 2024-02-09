//
//  UserRequest.swift
//  FakeNFT
//
//  Created by Artem Dubovitsky on 30.01.2024.
//
import Foundation

struct UserRequest: NetworkRequest {
    let id: String
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/users/\(id)")
    }
}
