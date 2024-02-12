//
//  ProfileRequest.swift
//  FakeNFT
//
//  Created by Artem Dubovitsky on 03.02.2024.
//
import Foundation

struct ProfileRequest: NetworkRequest {
    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/profile/1")
    }
}
