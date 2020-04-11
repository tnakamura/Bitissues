//
//  Kind.swift
//  Bitissues
//
//  Created by tnakamura on 2015/05/15.
//  Copyright (c) 2015年 tnakamura. All rights reserved.
//

import Foundation

/**
 * 種類
 */
enum Kind : String {
    case Bug = "bug"
    
    case Enhancement = "enhancement"
    
    case Proposal = "proposal"
    
    case Task = "task"
    
    static func allKind() -> [Kind] {
        var allKind = [Kind]()
        allKind.append(.Bug)
        allKind.append(.Enhancement)
        allKind.append(.Proposal)
        allKind.append(.Task)
        return allKind
    }
}