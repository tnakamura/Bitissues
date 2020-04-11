//
//  Models.swift
//  Bitissues
//
//  Created by tnakamura on 2014/09/17.
//  Copyright (c) 2014年 tnakamura. All rights reserved.
//

import Foundation
import CoreData

/**
 * お気に入り
 */
@objc(Favorite)
class Favorite: NSManagedObject {

    /**
     * ログイン名
     */
    @NSManaged var login: String
    
    /**
     * リポジトリオーナー
     */
    @NSManaged var owner: String
    
    /**
     * リポジトリ名
     */
    @NSManaged var name: String
    
    /**
     * スラグ名
     */
    @NSManaged var slug: String
    
    /**
     * 作成日時
     */
    @NSManaged var createdAt: NSDate
    
    /**
     * 更新日時
     */
    @NSManaged var updatedAt: NSDate
    
    /**
     * 並び順
     */
    @NSManaged var order: NSNumber

}
