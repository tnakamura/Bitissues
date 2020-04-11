//
//  CommentViewModel.swift
//  Bitissues
//
//  Created by tnakamura on 2014/09/25.
//  Copyright (c) 2014年 tnakamura. All rights reserved.
//

import UIKit

class CommentViewModel: NSObject {
    var repository: Repository!
    var issue: Issue!
    var client: BitbucketClient!
    var account: Account!
    var comment: String?

    func canPostComment() -> Bool {
        if self.comment == nil || self.comment!.isEmpty {
            return false
        } else {
            return true
        }
    }

    func postComment() -> RACSignal {
        let signal = self.client.postComment(
            self.comment!,
            accountName: self.account.name,
            repoSlug: self.repository.slug!,
            issueId: self.issue.localId
        )
        signal.map({ (response) -> AnyObject! in
            self.comment = nil
            return response
        })
        return signal
    }
}

