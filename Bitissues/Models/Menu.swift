//
//  Menu.swift
//  Bitissues
//
//  Created by tnakamura on 2014/10/04.
//  Copyright (c) 2014年 tnakamura. All rights reserved.
//

import UIKit

class Menu : NSObject {
    let title: String
    let imageUrl: String?
    let image: UIImage?
    
    init(title: String, image: UIImage) {
        self.title = title
        self.image = image
        self.imageUrl = nil
    }
    
    init(account: Account) {
        self.title = account.name
        self.image = nil
        self.imageUrl = account.avator
    }
}
