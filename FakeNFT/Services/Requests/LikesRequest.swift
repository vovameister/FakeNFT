//
//  LikesRequest.swift
//  FakeNFT
//
//  Created by Ramilia on 04/02/24.
//

import Foundation

struct GetLikesRequest: NetworkRequest {

    var httpMethod: HttpMethod { .get }

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
}

struct PutLikesRequest: NetworkRequest {

    var likes: [String]

    var httpMethod: HttpMethod { .put }

    var body: Data? {
        return likesToString().data(using: .utf8)
    }

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }

    private func likesToString() -> String {
        var likeString = "likes="

        if likes.isEmpty {
            likeString = ""
        } else {
            for (index, like) in likes.enumerated() {
                likeString += like
                if index != likes.count - 1 {
                    likeString += "&likes="
                }
            }
        }
        return likeString
    }
}
