//
//  ProfilePutRequest.swift
//  FakeNFT
//
//  Created by Владимир Клевцов on 4.2.24..
//

import Foundation

struct ProfilePutRequest: NetworkRequest {
    let name: String
    // let avatar: String
    let description: String
    let website: String

    var httpMethod: HttpMethod { .put }

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }

    var body: Data? {
        let body = "name= \(name) &description= \(description) &website= \(website)"
        return body.data(using: .utf8)!
    }
}
