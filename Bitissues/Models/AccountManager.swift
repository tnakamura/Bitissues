//
//  AccountManager.swift
//  Bitissues
//
//  Created by tnakamura on 2014/09/15.
//  Copyright (c) 2014年 tnakamura. All rights reserved.
//

import UIKit

class AccountManager: NSObject {
    let ServiceName = "Bitbucket"
    let AccountKey = "BitbucketAccount"
    let AvatarKey = "BitbucketAvatar"
    var currentAccount: Account?

    class var sharedManager: AccountManager {
        struct Singleton {
            static let instance: AccountManager = AccountManager()
        }
        return Singleton.instance
    }
    
    func saveAccount(account: Account) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(account.name, forKey: AccountKey)
        defaults.setValue(account.avator, forKey: AvatarKey)
        SSKeychain.setPassword(
            account.password,
            forService: ServiceName,
            account: account.name
        )
        self.currentAccount = account
    }
    
    func loadAccount() -> Account? {
        let defaults = NSUserDefaults.standardUserDefaults()
        guard let name = defaults.objectForKey(AccountKey) as? String else {
            return nil
        }
        guard let password = SSKeychain.passwordForService(ServiceName, account: name) else {
            return nil
        }
        self.currentAccount = Account(name: name, password: password, avatar: nil)
        return self.currentAccount
    }
    
    func logout() {
        if let account = self.currentAccount {
            self.destroyAccount(account)
        }
        self.currentAccount = nil
    }
    
    func isLoggedIn() -> Bool {
        return self.currentAccount != nil
    }
    
    private func destroyAccount(account: Account) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey(AccountKey)
        defaults.removeObjectForKey(AvatarKey)
        SSKeychain.deletePasswordForService(ServiceName, account: account.name)
    }
}
