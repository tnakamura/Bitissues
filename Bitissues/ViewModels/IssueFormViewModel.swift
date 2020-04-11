//
//  IssueFormViewModel.swift
//  Bitissues
//
//  Created by tnakamura on 2014/09/16.
//  Copyright (c) 2014年 tnakamura. All rights reserved.
//

import UIKit

class IssueFormViewModel: NSObject {
    private var _issue: Issue
    
    private var _repository: Repository

    var client: BitbucketClient!
    
    var title: String?
    
    var content: String?
    
    var priority: Priority
    
    var kind: Kind
    
    var responsible: String?
    
    var isNew: Bool = true
    
    /**
     * リポジトリを取得します。
     */
    var repository: Repository {
        return self._repository
    }
    
    /**
     * イシュー ID を取得します。
     */
    var issueId: Int {
        return self._issue.localId
    }

    init(repository: Repository) {
        self._repository = repository
        self._issue = Issue()
        self.title = self._issue.title
        self.content = self._issue.content
        self.priority = self._issue.priority
        self.kind = self._issue.metadata.kind
        self.responsible = self._issue.responsible?.username
    }

    init(repository: Repository, issue: Issue) {
        self._repository = repository.clone()
        self._issue = issue.clone()
        self.title = self._issue.title
        self.content = self._issue.content
        self.priority = self._issue.priority
        self.kind = self._issue.metadata.kind
        self.responsible = self._issue.responsible?.username
        self.isNew = false
    }

    func apply() -> Issue {
        let issue = self._issue.clone()
        issue.title = self.title
        issue.content = self.content
        issue.priority = self.priority
        issue.metadata.kind = self.kind

        if issue.responsible == nil {
            issue.responsible = User()
        }
        issue.responsible!.username = self.responsible
        
        return issue
    }

    func saveIssue() -> RACSignal {
        if self.isNew {
            return self.createIssue()
        } else {
            return self.updateIssue()
        }
    }

    private func createIssue() -> RACSignal {
        let issue = self.apply()
        return self.client.createIssue(
            issue,
            accountName: self.repository.owner!,
            repoSlug: self.repository.slug!
        )
    }

    private func updateIssue() -> RACSignal {
        let issue = self.apply()
        return self.client.updateIssue(
            issue,
            accountName: self.repository.owner!,
            repoSlug: self.repository.slug!
        )
    }
}

