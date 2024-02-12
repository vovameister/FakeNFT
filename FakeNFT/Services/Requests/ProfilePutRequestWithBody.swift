//
//  ProfilePutRequestWithBody.swift
//  FakeNFT
//
//  Created by Владимир Клевцов on 12.2.24..
//

import Foundation

struct ProfilePutRequestWithBody: NetworkRequest {
    let name: String
    let description: String
    let website: String
    let likes: [String]

    var params: String {
        var params = ""
        likes.forEach {
            params += "likes=" + $0 + "&"
        }
        return params
    }

    var httpMethod: HttpMethod { .put }

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1?\(params)")
    }

    var body: Data? {
        let body = "name=\(name)&description=\(description)&website=\(website)"
        return body.data(using: .utf8)!
    }
}
