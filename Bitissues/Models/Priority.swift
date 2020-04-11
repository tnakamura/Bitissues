//
//  Priority.swift
//  Bitissues
//
//  Created by tnakamura on 2015/05/15.
//  Copyright (c) 2015年 tnakamura. All rights reserved.
//

import Foundation

/**
 * 優先度
 */
enum Priority : String {
    case Trivial = "trivial"

    case Minor = "minor"
    
    case Major = "major"
    
    case Critical = "critical"
    
    case Blocker = "blocker"
}