//
//  GCD.swift
//  Bitissues
//
//  Created by tnakamura on 2014/09/21.
//  Copyright (c) 2014年 tnakamura. All rights reserved.
//

import Foundation

func dispatch_async_main(block: () -> ()) {
    dispatch_async(dispatch_get_main_queue(), block)
}

func dispatch_async_global(block: () -> ()) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
}