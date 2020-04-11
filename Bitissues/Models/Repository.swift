//
//  Repository.swift
//  Bitissues
//
//  Created by tnakamura on 2014/09/07.
//  Copyright (c) 2014年 tnakamura. All rights reserved.
//

import UIKit

/**
 * リポジトリ
 */
class Repository: NSObject {
   
    /**
     * リポジトリオーナー
     */
    var owner: String?
    
    /**
     * スラグ名
     */
    var slug: String?
    
    /**
     * リポジトリ名
     */
    var name: String?
    
    /**
     * プライベートリポジトリかどうか
     */
    var isPrivate: Bool = false

    /**
     * 表示名
     */
    var displayName: String? {
        guard let _owner = self.owner else {
            return nil
        }
        guard let _name = self.name else {
            return nil
        }
        return "\(_owner)/\(_name)"
    }
    
    override init() {
    }
    
    init(dictionary: NSDictionary!) {
        if let owner = dictionary.objectForKey("owner") as? String {
            self.owner = owner
        }
        if let slug = dictionary.objectForKey("slug") as? String {
            self.slug = slug
        }
        if let name = dictionary.objectForKey("name") as? String {
            self.name = name
        }
        if let isPrivate = dictionary.objectForKey("is_private") as? Bool {
            self.isPrivate = isPrivate
        }
    }
    
    func clone() -> Repository {
        let repos = Repository()
        repos.name = self.name
        repos.slug = self.slug
        repos.owner = self.owner
        repos.isPrivate = self.isPrivate
        return repos
    }
}
