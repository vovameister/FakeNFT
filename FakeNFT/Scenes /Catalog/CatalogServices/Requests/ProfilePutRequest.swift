//
//  ProfilePutRequest.swift
//  FakeNFT
//
//  Created by Artem Dubovitsky on 03.02.2024.
//
import Foundation

struct ProfilePutRequest: NetworkRequest {
    var httpMethod: HttpMethod = .put
    var dto: Encodable?
    var likes: Set<String>
    var body: Data? {
        return likesToString().data(using: .utf8)
    }

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }

    init(dto: Encodable? = nil, likes: Set<String>) {
        self.dto = dto
        self.likes = likes
    }

    func likesToString() -> String {
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
