//
//  Comment.swift
//  Bitissues
//
//  Created by tnakamura on 2014/09/07.
//  Copyright (c) 2014年 tnakamura. All rights reserved.
//

import UIKit

class Comment: NSObject {
    var commentId: Int = 0
    var content: String?
    var authorInfo: User?
    var isSpam = false
    var utcCreatedOn: String?
    
    override init() {
    }
    
    init(dictionary: NSDictionary) {
        if let commentId = dictionary.objectForKey("comment_id") as? Int {
            self.commentId = commentId
        }
        if let content = dictionary.objectForKey("content") as? String {
            self.content = content
        }
        if let isSpam = dictionary.objectForKey("is_spam") as? Bool {
            self.isSpam = isSpam
        }
        if let utcCreatedOn = dictionary.objectForKey("utc_created_on") as? String {
            self.utcCreatedOn = utcCreatedOn
        }
        if let authorDict = dictionary.objectForKey("author_info") as? NSDictionary {
            self.authorInfo = User(dictionary: authorDict)
        }
    }
    
    func clone() -> Comment {
        let other = Comment()
        other.commentId = self.commentId
        other.content = self.content
        other.isSpam = self.isSpam
        other.authorInfo = self.authorInfo?.clone()
        other.utcCreatedOn = self.utcCreatedOn
        return other
    }
}
