//
//  User.swift
//  Bitissues
//
//  Created by tnakamura on 2014/09/07.
//  Copyright (c) 2014年 tnakamura. All rights reserved.
//

import UIKit

/**
 * ユーザー
 */
class User: NSObject {
    
    /**
     * ユーザー名
     */
    var username: String?
    
    /**
     * ファーストネーム
     */
    var firstName: String?
    
    /**
     * ラストネーム
     */
    var lastName: String?
    
    /**
     * チームかどうか
     */
    var isTeam = false
    
    /**
     * アバター URL
     */
    var avatar: String?
    
    /**
     * REST URL
     */
    var resourceUri: String?
    
    override init() {
    }
    
    init(dictionary: NSDictionary) {
        if let username = dictionary.objectForKey("username") as? String {
            self.username = username
        }
        if let firstName = dictionary.objectForKey("first_name") as? String {
            self.firstName = firstName
        }
        if let lastName = dictionary.objectForKey("last_name") as? String {
            self.lastName = lastName
        }
        if let isTeam = dictionary.objectForKey("is_team") as? Bool {
            self.isTeam = isTeam
        }
        if let avatar = dictionary.objectForKey("avatar") as? String {
            self.avatar = avatar
        }
        if let resourceUri = dictionary.objectForKey("resource_uri") as? String {
            self.resourceUri = resourceUri
        }
    }
    
    func clone() -> User {
        let user = User()
        user.username = self.username
        user.firstName = self.firstName
        user.lastName = self.lastName
        user.isTeam = self.isTeam
        user.avatar = self.avatar
        user.resourceUri = self.resourceUri
        return user
    }
}
