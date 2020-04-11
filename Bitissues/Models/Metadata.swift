//
//  Metadata.swift
//  Bitissues
//
//  Created by tnakamura on 2014/09/07.
//  Copyright (c) 2014年 tnakamura. All rights reserved.
//

import UIKit

class Metadata: NSObject {
    var kind: Kind = Kind.Bug
    
    var version: String?
    
    var component: String?
    
    var milestone: String?

    override init() {
    }

    init(dictionary: NSDictionary) {
        if let rawKind = dictionary.objectForKey("kind") as? String {
            if let kind = Kind(rawValue: rawKind) {
                self.kind = kind
            }
        }
        
        if let version = dictionary.objectForKey("version") as? String {
            self.version = version
        }
        
        if let component = dictionary.objectForKey("component") as? String {
            self.component = component
        }
        
        if  let milestone = dictionary.objectForKey("milestone") as? String {
            self.milestone = milestone
        }
    }
    
    func clone() -> Metadata {
        let meta = Metadata()
        meta.kind = self.kind
        meta.version = self.version
        meta.component = self.component
        meta.milestone = self.milestone
        return meta
    }
}
