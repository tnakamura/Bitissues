//
//  Status.swift
//  Bitissues
//
//  Created by tnakamura on 2015/05/15.
//  Copyright (c) 2015年 tnakamura. All rights reserved.
//

import Foundation

/**
 * ステータス
 */
enum Status : String {
    case New = "new"
    
    case Open = "open"
    
    case Resolved = "resolved"
    
    case OnHold = "on hold"
    
    case Invalid = "invalid"
    
    case Duplicate = "duplicate"
    
    case Wontfix = "wontfix"
    
    static func allStatus() -> [Status] {
        var allStatus = [Status]()
        allStatus.append(.New)
        allStatus.append(.Open)
        allStatus.append(.Resolved)
        allStatus.append(.OnHold)
        allStatus.append(.Invalid)
        allStatus.append(.Duplicate)
        allStatus.append(.Wontfix)
        return allStatus
    }
}