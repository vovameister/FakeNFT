//
//  ProfileService.swift
//  FakeNFT
//
//  Created by Владимир Клевцов on 15.1.24..
//

import Foundation

final class ProfileService {
    static let shared = ProfileService()
    
    var oldAvatarURL: String?
    
    var newAvatarURL: String?
    
    var userName: String? {
        didSet {
            UserDefaults.standard.set(userName, forKey: "userName")
        }
    }
    var userDescription: String? {
        didSet {
            UserDefaults.standard.set(userDescription, forKey: "userDescription")
        }
    }
    var website: String? {
        didSet {
            UserDefaults.standard.set(website, forKey: "userWebsite")
        }
    }
    
    
    init(webLink: String? = nil) {
        if let savedAvatarURL = UserDefaults.standard.string(forKey: "userURL") {
            self.oldAvatarURL = savedAvatarURL
        }
        if let savedUserName = UserDefaults.standard.string(forKey: "userName") {
            self.userName = savedUserName
            print("Saved UserName: \(savedUserName)")
        } else {
            print("no name")
        }

        if let savedUserDescription = UserDefaults.standard.string(forKey: "userDescription") {
            self.userDescription = savedUserDescription
            print("Saved User Description: \(savedUserDescription)")
        }

        if let savedWebsite = UserDefaults.standard.string(forKey: "userWebsite") {
            self.website = savedWebsite
            print("Saved Website: \(savedWebsite)")
        }
    }
    
    func saveAvater() {
        if newAvatarURL != nil {
            UserDefaults.standard.set(newAvatarURL, forKey: "userURL")
            oldAvatarURL = newAvatarURL
        }
    }
}

