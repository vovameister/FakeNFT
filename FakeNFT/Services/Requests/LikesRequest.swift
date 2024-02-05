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
    
    var params: String {
        var params = ""
        likes.forEach {
            params += "likes=" + $0 + "&"
        }
        params.removeLast()
        return params
    }
    
    var httpMethod: HttpMethod { .put }
    
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1?\(params)")
    }
}
