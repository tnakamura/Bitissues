//
//  FilterViewModel.swift
//  Bitissues
//
//  Created by tnakamura on 2014/09/16.
//  Copyright (c) 2014年 tnakamura. All rights reserved.
//

import UIKit

class FilterViewModel: NSObject {
    private var filter: Filter
    var repository: Repository!
    var responsible: String?
    var kind: Kind?
    var priority: Priority?
    var isOpen: Bool = true
    var sort: FilterSort = FilterSort.UpdatedOnDesc

    override init() {
        self.filter = Filter.defaultFilter()
        super.init()
        self.initializeProperties(self.filter)
    }

    init(filter: Filter?) {
        if filter != nil {
            self.filter = filter!.clone()
        } else {
            self.filter = Filter.defaultFilter()
        }
        super.init()
        self.initializeProperties(self.filter)
    }

    private func initializeProperties(filter: Filter) {
        self.responsible = filter.responsible
        self.kind = filter.kind
        self.priority = filter.priority
        self.isOpen = filter.isOpen
        self.sort = filter.sort
    }

    func apply() -> Filter {
        let filter = Filter()
        filter.responsible = self.responsible
        if self.kind != nil {
            filter.kind = self.kind!
        }
        if self.priority != nil {
            filter.priority = self.priority!
        }
        filter.isOpen = self.isOpen
        filter.sort = self.sort
        return filter
    }

    func reset() {
        self.initializeProperties(self.filter)
    }
}
