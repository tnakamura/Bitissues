//
//  Account.swift
//  Bitissues
//
//  Created by tnakamura on 2014/09/07.
//  Copyright (c) 2014年 tnakamura. All rights reserved.
//

import UIKit

struct Account {
    let name: String
    let password: String
    let avator: String?
    
    init(name: String, password: String, avatar: String?) {
        self.name = name
        self.password = password
        self.avator = avatar
    }
}
