//
//  IssuesViewModel.swift
//  Bitissues
//
//  Created by tnakamura on 2014/09/12.
//  Copyright (c) 2014年 tnakamura. All rights reserved.
//

import UIKit

class IssuesViewModel: NSObject {
    var repository: Repository?
    var account: Account?
    var client: BitbucketClient?
    var searchText: String?
    var filter: Filter?
    var favorite: Favorite?
    var hasNextPage: Bool = false
    var isUpdating: Bool = false
    private var issues: [Issue]
    
    override init() {
        self.issues = [Issue]()
    }
    
    func issueCount() -> Int {
        return self.issues.count
    }
    
    func issueAtIndex(index: Int) -> Issue {
        return self.issues[index]
    }
    
    func loadIssues() -> RACSignal {
        self.isUpdating = true

        let signal = self.client!.fetchIssues(
            self.repository!.owner!,
            repoSlug: self.repository!.slug!,
            offset: 0,
            filter: self.filter,
            search: self.searchText
        )

        return signal.map({ (response) -> AnyObject! in
            let fetchedIssues = response as! [Issue]
            if 20 < fetchedIssues.count {
                self.hasNextPage = true
                self.issues = fetchedIssues
            } else {
                self.hasNextPage = false
                self.issues = fetchedIssues
            }
            self.isUpdating = false
            return response
        })
    }

    func loadNextIssues() -> RACSignal {
        self.isUpdating = true

        let signal = self.client!.fetchIssues(
            self.repository!.owner!,
            repoSlug: self.repository!.slug!,
            offset: self.issues.count,
            filter: self.filter,
            search: self.searchText
        )
        
        return signal.map({ (response) -> AnyObject! in
            let fetchedIssues = response as! [Issue]
            if 20 < fetchedIssues.count {
                self.hasNextPage = true
                for issue in fetchedIssues {
                    self.issues.append(issue)
                }
            } else {
                self.hasNextPage = false
                for issue in fetchedIssues {
                    self.issues.append(issue)
                }
            }
            self.isUpdating = false
            return response
        })
    }

    func loadFavorite() -> RACSignal {
        let signal = Favorite.findWithLogin(
            self.account!.name,
            owner: self.repository!.owner!,
            repoSlug: self.repository!.slug!
        )
        return signal.map({ (response) -> AnyObject! in
            self.favorite = response as! Favorite?
            return response
        })
    }

    func createFavorite() -> RACSignal {
        let signal = Favorite.createAsync(self.account!.name, repository: self.repository!)
        return signal.map({ (response) -> AnyObject! in
            self.favorite = response as! Favorite?
            return response
        })
    }

    func deleteFavorite() -> RACSignal {
        let signal = self.favorite!.destroyAsync()
        return signal.map({ (response) -> AnyObject! in
            self.favorite = nil
            return response
        })
    }
}
