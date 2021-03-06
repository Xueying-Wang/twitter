//
//  User.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/17/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import Foundation

class User {
    
    var name: String?
    var screenName: String?
    var avatarURL: URL?
    var backgroundURL: URL?
    var followers_count: Int?
    var following_count: Int?
    var description: String?
    
    var dictionary: [String: Any]?
    
    private static var _current: User?
    
    static var current: User? {
        get {
            if _current == nil {
                let defaults = UserDefaults.standard
                if let userData = defaults.data(forKey: "currentUserData") {
                    let dictionary = try! JSONSerialization.jsonObject(with: userData, options: []) as! [String: Any]
                    _current = User(dictionary: dictionary)
                }
            }
            return _current
        }
        set (user) {
            _current = user
            let defaults = UserDefaults.standard
            if let user = user {
                let data = try! JSONSerialization.data(withJSONObject: user.dictionary!, options: [])
                defaults.set(data, forKey: "currentUserData")
            } else {
                defaults.removeObject(forKey: "currentUserData")
            }
        }
    }
    
    init(dictionary: [String: Any]) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenName = dictionary["screen_name"] as? String
        avatarURL = URL(string: (dictionary["profile_image_url_https"] as? String)!)
        if dictionary["profile_banner_url"] != nil {
            backgroundURL = URL(string: (dictionary["profile_banner_url"] as? String)!)
        } else if let urlString = dictionary["profile_background_image_url_https"] as? String {
            backgroundURL = URL(string: urlString)
        }
        followers_count = dictionary["followers_count"] as? Int
        following_count = dictionary["friends_count"] as? Int
        description = dictionary["description"] as? String ?? ""
    }
}
