//
//  UsersRequest.swift
//  FakeNFT
//
//  Created by Ramilia on 04/02/24.
//

import Foundation

struct UsersRequest: NetworkRequest {

    var httpMethod: HttpMethod { .get }

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/users")
    }
}

struct UserInfoRequest: NetworkRequest {

    let id: String

    var httpMethod: HttpMethod { .get }

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/users/\(id)")
    }
}

struct UserNftRequest: NetworkRequest {

    let id: String

    var httpMethod: HttpMethod { .get }

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/nft/\(id)")
    }
}
