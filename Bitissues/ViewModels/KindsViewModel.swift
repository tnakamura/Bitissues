//
//  KindsViewModel.swift
//  Bitissues
//
//  Created by tnakamura on 2014/09/17.
//  Copyright (c) 2014年 tnakamura. All rights reserved.
//

import UIKit

class KindsViewModel: ItemsViewModel {
    override init() {
        super.init()
        self.title = "Kinds"
    }
    
    override func loadItems() -> RACSignal {
        self.items = ["bug", "enhancement", "proposal", "task"]
        return RACSignal.createSignal({ (subscriber: RACSubscriber!) -> RACDisposable! in
            subscriber.sendNext(self.items)
            subscriber.sendCompleted()
            return nil
        })
    }
}

