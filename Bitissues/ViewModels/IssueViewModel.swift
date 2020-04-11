//
//  IssueViewModel.swift
//  Bitissues
//
//  Created by tnakamura on 2014/09/12.
//  Copyright (c) 2014年 tnakamura. All rights reserved.
//

import UIKit

class IssueViewModel: NSObject {
    private var issue_: Issue
    private var _repository: Repository
    private var comments: [Comment]
    var client: BitbucketClient!
    var account: Account!
    
    init(repository: Repository, issue: Issue) {
        self._repository = repository.clone()
        self.issue_ = issue.clone()
        self.comments = [Comment]()
    }
    
    /**
     * イシューを取得します。
     *
     * - returns: イシュー
     */
    var issue: Issue {
        return self.issue_
    }
    
    /**
     * リポジトリを取得します。
     *
     * - returns: リポジトリ
     */
    var repository: Repository {
        return self._repository
    }
    
    /**
     * イシュー ID を取得します。
     *
     * - returns: イシュー ID
     */
    var issueId: Int {
        return self.issue.localId
    }
    
    /**
     * 担当者名を取得します。
     *
     * - returns: 担当者名
     */
    var responsible: String? {
        return self.issue.responsible?.username
    }
    
    /**
     * タイトルを取得します。
     *
     * - returns: タイトル
     */
    var title: String? {
        return self.issue.title
    }
    
    /**
     * 本文を取得します。
     *
     * - returns: 本文
     */
    var content: String? {
        return self.issue.content
    }
    
    /**
     * ステータスを取得します。
     *
     * - returns: ステータス
     */
    var status: Status {
        return self.issue.status
    }
    
    /**
     * 優先度を取得します。
     *
     * - returns: 優先度
     */
    var priority: Priority {
        return self.issue.priority
    }
    
    /**
     * 種類を取得します。
     *
     * - returns: 種類
     */
    var kind: Kind {
        return self.issue.metadata.kind
    }
    
    /**
     * コメント数を取得します。
     *
     * - returns: コメント数
     */
    func commentCount() -> Int {
        return self.comments.count
    }
    
    func commentAtIndex(index: Int) -> Comment {
        return self.comments[index]
    }

    func loadIssue() -> RACSignal {
        let signal = self.client.fetchIssue(
            self.repository.owner!,
            repoSlug: self.repository.slug!,
            issueId: self.issue.localId)
        return signal.map({ (response) -> AnyObject! in
            self.issue_ = response as! Issue
            return response
        })
    }
    
    func loadComments() -> RACSignal {
        let signal = self.client.fetchComments(
            self.repository.owner!,
            repoSlug: self.repository.slug!,
            issueId: self.issue.localId)
        return signal.map({ (comments) -> AnyObject! in
            self.comments = comments as! [Comment]
            return comments
        })
    }
}
