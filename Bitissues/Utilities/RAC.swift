//
//  RAC.swift
//  Bitissues
//
//  Created by tnakamura on 2014/09/16.
//  Copyright (c) 2014年 tnakamura. All rights reserved.
//

struct RAC {
    var target: NSObject!
    var keyPath: String!
    var nilValue: AnyObject!

    init(target: NSObject!, keyPath: String!, nilValue: AnyObject? = nil) {
        self.target = target
        self.keyPath = keyPath
        self.nilValue = nilValue
    }

    func assignSignal(signal: RACSignal) {
        signal.setKeyPath(self.keyPath, onObject: self.target, nilValue: self.nilValue)
    }
}

func RACObserve(target: NSObject, keyPath: String) -> RACSignal {
    return target.rac_valuesForKeyPath(keyPath, observer: target)
}

