//
//  ItemsViewModel.swift
//  Bitissues
//
//  Created by tnakamura on 2014/09/17.
//  Copyright (c) 2014年 tnakamura. All rights reserved.
//

import UIKit

class ItemsViewModel: NSObject {
    var title: String?
    var items: [String] = [String]()
    var selectedItem: String?

    func itemCount() -> Int {
        return self.items.count
    }

    func itemAtIndex(index: Int) -> String {
        return self.items[index]
    }

    func loadItems() -> RACSignal {
        return RACSignal.empty()
    }
}

