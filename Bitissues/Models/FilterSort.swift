//
//  FilterSort.swift
//  Bitissues
//
//  Created by tnakamura on 2014/09/18.
//  Copyright (c) 2014年 tnakamura. All rights reserved.
//

import UIKit

/**
 * イシューの並び順を定義します。
 */
enum FilterSort: String {
    
    /**
     * 作成日付降順
     */
    case CreatedOnDesc = "-created_on"
    
    /**
     * 作成日付昇順
     */
    case CreatedOnAsc = "+created_on"
    
    /**
     * 更新日付降順
     */
    case UpdatedOnDesc = "-updated_on"
    
    /**
     * 更新日付昇順
     */
    case UpdatedOnAsc = "+updated_on"
    
    /**
     * クエリパラメータに変換します。
     *
     * - returns: クエリパラメータ
     */
    func toQuery() -> String {
        switch self {
        case .CreatedOnAsc:
            return "sort=created_on"
        case .CreatedOnDesc:
            return "sort=-created_on"
        case .UpdatedOnAsc:
            return "sort=utc_last_updated"
        case .UpdatedOnDesc:
            return "sort=-utc_last_updated"
        }
    }
    
    /**
     * プロンプト表示用テキストに変換します。
     *
     * - returns: プロンプト表示用テキスト
     */
    func toPrompt() -> String? {
        switch self {
        case .CreatedOnAsc:
            return "Sort:Created asc"
        case .CreatedOnDesc:
            return nil
        case .UpdatedOnAsc:
            return "Sort:Updated asc"
        case .UpdatedOnDesc:
            return "Sort:Updated desc"
        }
    }
}

