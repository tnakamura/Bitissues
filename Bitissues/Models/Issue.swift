//
//  Issue.swift
//  Bitissues
//
//  Created by tnakamura on 2014/09/07.
//  Copyright (c) 2014年 tnakamura. All rights reserved.
//

import UIKit

/**
 * イシュー
 */
class Issue: NSObject {
    
    /**
     * ステータス
     */
    var status: Status = Status.New
    
    /**
     * 優先度
     */
    var priority: Priority = Priority.Major
    
    /**
     * タイトル
     */
    var title: String?
    
    /**
     * 本文
     */
    var content: String?
    
    /**
     * イシュー ID
     */
    var localId: Int = 0
    
    var resourceUri: String?
    
    /**
     * スパムかどうか
     */
    var isSpam = false
    
    /**
     * 報告者
     */
    var reportedBy: User?
    
    /**
     * 担当者
     */
    var responsible: User?
    
    /**
     * メタデータ
     */
    var metadata: Metadata
    
    /**
     * 作成日時
     */
    var createdOn: String?
    
    override init() {
        self.metadata = Metadata()
    }
    
    init(dictionary: NSDictionary!) {
        if let rawStatus = dictionary.objectForKey("status") as? String {
            if let status = Status(rawValue: rawStatus) {
                self.status = status
            }
        }
        
        if let rawPriority = dictionary.objectForKey("priority") as? String {
            if let priority = Priority(rawValue: rawPriority) {
                self.priority = priority
            }
        }
        
        if let title = dictionary.objectForKey("title") as? String {
            self.title = title
        }
        
        if let resourceUri = dictionary.objectForKey("resource_uri") as? String {
            self.resourceUri = resourceUri
        }
        
        if let localId = dictionary.objectForKey("local_id") as? Int {
            self.localId = localId
        }
        
        if let isSpam = dictionary.objectForKey("is_spam") as? Bool {
            self.isSpam = isSpam
        }
        
        if let content = dictionary.objectForKey("content") as? String {
            self.content = content
        }
        
        if let createdOn = dictionary.objectForKey("created_on") as? String {
            self.createdOn = createdOn
        }
        
        if let reportedBy = dictionary.objectForKey("reported_by") as? NSDictionary {
            self.reportedBy = User(dictionary: reportedBy)
        }
        
        if let responsible = dictionary.objectForKey("responsible") as? NSDictionary {
            self.responsible = User(dictionary: responsible)
        }
        
        if let metadataDic = dictionary.objectForKey("metadata") as? NSDictionary {
            self.metadata = Metadata(dictionary: metadataDic)
        } else {
            self.metadata = Metadata()
        }
    }
    
    /**
     * 新しいイシューかどうか
     *
     * - returns: 新しいイシューのとき true、それ以外のとき false
     */
    func isNew() -> Bool {
        return 0 < self.localId
    }
    
    func copyTo(issue: Issue) {
        issue.status = self.status
        issue.priority = self.priority
        issue.title = self.title
        issue.content = self.content
        issue.localId = self.localId
        issue.resourceUri = self.resourceUri
        issue.isSpam = self.isSpam
        issue.reportedBy = self.reportedBy?.clone()
        issue.responsible = self.responsible?.clone()
        issue.metadata = self.metadata.clone()
        issue.createdOn = self.createdOn
    }
    
    func clone() -> Issue {
        let issue = Issue()
        self.copyTo(issue)
        return issue
    }

    func toParams() -> NSDictionary {
        let dict = NSMutableDictionary()
        dict.setValue(self.title!, forKey: "title")
      
        if self.content != nil {
            dict.setValue(self.content!, forKey: "content")
        }
      
        dict.setValue(self.priority.rawValue, forKey: "priority")
        dict.setValue(self.status.rawValue, forKey: "status")
        dict.setValue(self.metadata.kind.rawValue, forKey: "kind")

        if self.responsible != nil && self.responsible!.username != nil {
            dict.setValue(self.responsible!.username!, forKey: "responsible")
        }
        return dict
    }
}
