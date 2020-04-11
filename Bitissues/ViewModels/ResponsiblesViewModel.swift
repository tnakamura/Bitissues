//
//  ResponsiblesViewModel.swift
//  Bitissues
//
//  Created by tnakamura on 2014/09/17.
//  Copyright (c) 2014年 tnakamura. All rights reserved.
//

import UIKit

class ResponsiblesViewModel: ItemsViewModel {
    var client: BitbucketClient!
    var repository: Repository!
    
    override init() {
        super.init()
        self.title = "Responsibles"
    }
    
    override func loadItems() -> RACSignal {
        let signal = self.client.fetchPrivileges(
            self.repository.owner!,
            slug: self.repository!.slug!
        )
        return signal.map({ (next) -> AnyObject! in
            var userNames = [String]()
            if self.client.username != nil {
                userNames.append(self.client.username!)
            }
            
            let users = next as! [User]
            for user in users {
                userNames.append(user.username!)
            }
            
            self.items = userNames
            return userNames
        })
    }
}

