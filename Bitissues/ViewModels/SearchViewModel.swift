//
//  SearchViewModel.swift
//  Bitissues
//
//  Created by tnakamura on 2014/09/13.
//  Copyright (c) 2014年 tnakamura. All rights reserved.
//

import UIKit

class SearchViewModel: NSObject {
    var keyword: String?
    var client: BitbucketClient!
    private var repositories: [Repository] = [Repository]()

    func repositoryCount() -> Int {
        return self.repositories.count
    }

    func repositoryAtIndex(index: Int) -> Repository {
        return self.repositories[index]
    }

    func search() -> RACSignal {
        if self.keyword == nil || self.keyword!.isEmpty {
            return RACSignal.empty()
        }
        let signal = self.client.searchRepositories(self.keyword!)
        return signal.map({ (repositories) -> AnyObject! in
            self.repositories = repositories as! [Repository]
            return repositories
        })
    }
}
