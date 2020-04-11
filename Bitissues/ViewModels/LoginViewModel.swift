//
//  LoginViewModel.swift
//  Bitissues
//
//  Created by tnakamura on 2014/09/13.
//  Copyright (c) 2014年 tnakamura. All rights reserved.
//

import UIKit

class LoginViewModel: NSObject {
    var username: String?
    var password: String?
    var client: BitbucketClient!
    var manager: AccountManager!
    
    func login() -> RACSignal {
        self.client.username = self.username
        self.client.password = self.password
        let signal = self.client.fetchCurrentUser()
        return signal.map { (response) -> AnyObject! in
            guard let user = response as? User else {
                return response
            }
            guard let name = self.username else {
                return response
            }
            guard let pass = self.password else {
                return response
            }
            let account = Account(name: name, password: pass, avatar: user.avatar)
            self.manager.saveAccount(account)
            return user
        }
    }
    
    func isValid() -> Bool {
        if self.username == nil || self.username!.isEmpty {
            return false
        }
        if self.password == nil || self.password!.isEmpty {
            return false
        }
        return true
    }
}
