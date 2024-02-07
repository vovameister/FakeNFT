//
//  PutLikesRequest.swift
//  FakeNFT
//
//  Created by Владимир Клевцов on 6.2.24..
//

import Foundation

struct PutLikesRequest: NetworkRequest {
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
}
