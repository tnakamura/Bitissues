//
//  PrioritiesViewModel.swift
//  Bitissues
//
//  Created by tnakamura on 2014/09/17.
//  Copyright (c) 2014年 tnakamura. All rights reserved.
//

import UIKit

class PrioritiesViewModel: ItemsViewModel {
    override init() {
        super.init()
        self.title = "Priorities"
    }
    
    override func loadItems() -> RACSignal {
        self.items = ["trivial", "minor", "major", "critical", "blocker"]
        return RACSignal.createSignal({ (subscriber: RACSubscriber!) -> RACDisposable! in
            subscriber.sendNext(self.items)
            subscriber.sendCompleted()
            return nil
        })
    }
}

