//
//  Filter.swift
//  Bitissues
//
//  Created by tnakamura on 2014/09/07.
//  Copyright (c) 2014年 tnakamura. All rights reserved.
//

import UIKit

class Filter: NSObject {
    var responsible: String?
    var kind: Kind?
    var priority: Priority?
    var isOpen: Bool = true
    var sort: FilterSort = FilterSort.CreatedOnDesc

    func clone() -> Filter {
        let filter = Filter()
        filter.responsible = self.responsible
        filter.kind = self.kind
        filter.priority = self.priority
        filter.isOpen = self.isOpen
        filter.sort = self.sort
        return filter
    }
    
    func toQuery() -> String {
        let array = NSMutableArray()

        if self.responsible != nil {
            array.addObject("responsible=\(self.responsible!)")
        }

        if self.isOpen {
            array.addObject("status=new&status=open")
        } else {
            array.addObject("status=invalid&status=wontfix&status=duplicate&status=resolved&status=hold")
        }
        
        if self.kind != nil {
            array.addObject("kind=\(self.kind!.rawValue)")
        }
        
        if self.priority != nil {
            array.addObject("priority=\(self.priority!.rawValue)")
        }
        
        let sortQuery = self.sort.toQuery()
        array.addObject(sortQuery)
        
        let query = array.componentsJoinedByString("&")
        return query
    }
    
    class func defaultFilter() -> Filter {
        let filter = Filter()
        return filter
    }
    
    func isDefault() -> Bool {
        let defaultFilter = Filter()
        if self.responsible != defaultFilter.responsible {
            return false
        }
        if self.kind != defaultFilter.kind {
            return false
        }
        if self.priority != defaultFilter.priority {
            return false
        }
        if self.isOpen != defaultFilter.isOpen {
            return false
        }
        if self.sort != defaultFilter.sort {
            return false
        }
        return true
    }

    func toPrompt() -> String? {
        if isDefault() {
            return nil
        }
        
        let array = NSMutableArray()

        if self.responsible != nil {
            array.addObject("Assignee:\(self.responsible!)")
        }

        if self.kind != nil {
            array.addObject("Kind:\(self.kind!.rawValue)")
        }
        
        if self.priority != nil {
            array.addObject("Priority:\(self.priority!.rawValue)")
        }
        
        if !self.isOpen {
            array.addObject("Closed")
        }
    
        if let sortText = self.sort.toPrompt() {
            array.addObject(sortText)
        }
    
        let prompt = array.componentsJoinedByString(", ")
        return prompt
    }
}
