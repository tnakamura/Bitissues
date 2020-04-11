//
//  RepositoriesViewModel.swift
//  Bitissues
//
//  Created by tnakamura on 2014/09/12.
//  Copyright (c) 2014年 tnakamura. All rights reserved.
//

import UIKit

class RepositoriesViewModel: NSObject {
    private var repositories: [Repository]
    private var filteredRepositories: [Repository]?
    var client: BitbucketClient!
    var searchText: String?
    
    /**
     * ログインユーザー名を取得します。
     *
     * - returns: ログインユーザー名
     */
    var userName: String? {
        return self.client.username
    }
    
    override init() {
        self.repositories = [Repository]()
    }
    
    func repositoryCount() -> Int {
        if self.filteredRepositories != nil {
            return self.filteredRepositories!.count
        } else {
            return self.repositories.count
        }
    }
    
    func repositoryAtIndex(index: Int) -> Repository {
        if self.filteredRepositories != nil {
            return self.filteredRepositories![index]
        } else {
            return self.repositories[index]
        }
    }
    
    func loadRepositories() -> RACSignal {
        self.searchText = nil
        self.filteredRepositories = nil

        let signal = self.client.fetchRepositories()
        return signal.map { (repositories) -> AnyObject! in
            self.repositories = repositories as! [Repository]
            return repositories
        }
    }

    func filterRepositories() {
        if self.searchText == nil || self.searchText!.isEmpty {
            return
        }

        self.filteredRepositories = [Repository]()
        for repository in self.repositories {
            if repository.name?.rangeOfString(self.searchText!) != nil {
                self.filteredRepositories!.append(repository)
            }
        }
    }

    func resetFiltering() {
        self.searchText = nil
        self.filteredRepositories = nil
    }
}
