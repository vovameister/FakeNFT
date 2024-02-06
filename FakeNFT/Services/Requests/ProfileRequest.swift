//
//  ProfileRequest.swift
//  FakeNFT
//
//  Created by Владимир Клевцов on 31.1.24..
//
import Foundation

struct ProfileRequest: NetworkRequest {

    var httpMethod: HttpMethod { .get }

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
}
