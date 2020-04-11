//
//  BitbucketClient.swift
//  Bitissues
//
//  Created by tnakamura on 2014/09/09.
//  Copyright (c) 2014年 tnakamura. All rights reserved.
//

import UIKit

class BitbucketClient: NSObject {
    private let baseUrl = NSURL(string: "https://bitbucket.org/api/1.0/")
    var username: String?
    var password: String?
    
    class var sharedClient: BitbucketClient {
        get {
            struct Singleton {
                static let instance: BitbucketClient = BitbucketClient()
            }
            return Singleton.instance
        }
    }
    
    private func createManager() -> AFHTTPRequestOperationManager {
        let manager = AFHTTPRequestOperationManager(baseURL: baseUrl)
        manager.requestSerializer = AFHTTPRequestSerializer()
        manager.requestSerializer.setAuthorizationHeaderFieldWithUsername(
            username!, password: password!)
        return manager
    }
    
    func fetchRepositories() -> RACSignal {
        let manager = self.createManager()
        let signal = manager.rac_GET("user/repositories/", parameters: nil)        
        return signal.map({ (jsonAndHeader) -> AnyObject! in
            guard let tuple = jsonAndHeader as? RACTuple else {
                return jsonAndHeader
            }
            guard let array = tuple.first as? NSArray else {
                return jsonAndHeader
            }
            return self.convertToRepositories(array)
        });
    }
    
    private func convertToRepositories(array: NSArray) -> [Repository] {
        var repos = [Repository]()
        for obj in array {
            let dict = obj as! NSDictionary
            let repo = Repository(dictionary: dict)
            repos.append(repo)
        }
        return repos
    }
    
    func fetchIssues(
        owner: String,
        repoSlug: String,
        offset: Int = 0,
        filter: Filter? = nil,
        search: String? = nil
    ) -> RACSignal {
        var query: String
        if filter != nil {
            query = filter!.toQuery()
        } else {
            query = "status=new&status=open&sort=-created_on"
        }
        let path = "repositories/\(owner)/\(repoSlug)/issues?\(query)"

        // 次のページがあるかどうか判断するために 21 件取得する。
        // 表示するのは 20 件まで。
        // とりあえず new の課題を表示。
        var params = [String:String]()
        params["limit"] = "21"
        params["start"] = String(offset)
        if search != nil && search!.isEmpty == false {
            params["search"] = search!
        }

        let manager = self.createManager()
        let signal = manager.rac_GET(path, parameters: params)
        return signal.map({ (jsonAndHeader) -> AnyObject! in
            guard let tuple = jsonAndHeader as? RACTuple else {
                return jsonAndHeader
            }
            guard let dict = tuple.first as? NSDictionary else {
                return jsonAndHeader
            }
            guard let array = dict.objectForKey("issues") as? NSArray else {
                return jsonAndHeader
            }
            return self.convertToIssues(array)
        })
    }
    
    private func convertToIssues(array: NSArray) -> [Issue] {
        var issues = [Issue]()
        for obj in array {
            let dict = obj as! NSDictionary
            let issue = Issue(dictionary: dict)
            issues.append(issue)
        }
        return issues
    }

    func fetchIssue(owner: String, repoSlug: String, issueId: Int) -> RACSignal {
        let manager = self.createManager()
        let path = "repositories/\(owner)/\(repoSlug)/issues/\(issueId)"
        let signal = manager.rac_GET(path, parameters: nil)
        return signal.map({ (jsonAndHeader) -> AnyObject! in
            guard let tuple = jsonAndHeader as? RACTuple else {
                return jsonAndHeader
            }
            guard let dict = tuple.first as? NSDictionary else {
                return jsonAndHeader
            }
            return Issue(dictionary: dict)
        })
    }
    
    func fetchComments(owner: String, repoSlug: String, issueId: Int) -> RACSignal {
        let manager = self.createManager()
        let path = "repositories/\(owner)/\(repoSlug)/issues/\(issueId)/comments"
        let signal = manager.rac_GET(path, parameters: nil)
        return signal.map({ (jsonAndHeader) -> AnyObject! in
            guard let tuple = jsonAndHeader as? RACTuple else {
                return jsonAndHeader
            }
            guard let array = tuple.first as? NSArray else {
                return jsonAndHeader
            }
            return self.convertToComments(array)
        })
    }
    
    private func convertToComments(array: NSArray) -> [Comment] {
        var comments = [Comment]()
        for obj in array {
            let dict = obj as! NSDictionary
            let comment = Comment(dictionary: dict)
            if 0 < (comment.content!).characters.count {
                comments.append(comment)
            }
        }
        return comments
    }
    
    func fetchCurrentUser() -> RACSignal {
        let manager = self.createManager()
        let signal = manager.rac_GET("user", parameters: nil)
        return signal.map({ (jsonAndHeader) -> AnyObject! in
            guard let tuple = jsonAndHeader as? RACTuple else {
                return jsonAndHeader
            }
            guard let responseDict = tuple.first as? NSDictionary else {
                return jsonAndHeader
            }
            guard let userDict = responseDict.objectForKey("user") as? NSDictionary else {
                return jsonAndHeader
            }
            return User(dictionary: userDict)
        })
    }

    func searchRepositories(keyword: String) -> RACSignal {
        let params = ["name": keyword]
        let manager = self.createManager()
        let signal = manager.rac_GET("repositories", parameters: params)
        return signal.map({ (jsonAndHeader) -> AnyObject! in
            guard let tuple = jsonAndHeader as? RACTuple else {
                return jsonAndHeader
            }
            guard let responseDict = tuple.first as? NSDictionary else {
                return jsonAndHeader
            }
            guard let reposArray = responseDict.objectForKey("repositories") as? NSArray else {
                return jsonAndHeader
            }
            return self.convertToRepositories(reposArray)
        })
    }

    func fetchPrivileges(owner: String, slug: String) -> RACSignal {
        let path = "privileges/\(owner)/\(slug)"
        let params = ["filter": "write"]
        let manager = self.createManager()
        let signal = manager.rac_GET(path, parameters: params)
        return signal.map({ (jsonAndHeader) -> AnyObject! in
            guard let tuple = jsonAndHeader as? RACTuple else {
                return jsonAndHeader
            }
            guard let responseArray = tuple.first as? NSArray else {
                return jsonAndHeader
            }
            return self.convertToUsers(responseArray)
        })
    }

    private func convertToUsers(array: NSArray) -> [User] {
        var users = [User]()
        for obj in array {
            let dict = obj as! NSDictionary
            let userDict = dict.objectForKey("user") as! NSDictionary
            let user = User(dictionary: userDict)
            users.append(user)
        }
        return users
    }

    func postComment(comment: String, accountName: String, repoSlug: String, issueId: Int) -> RACSignal {
        let path = "repositories/\(accountName)/\(repoSlug)/issues/\(issueId)/comments"
        let params = ["content": comment]
        let manager = self.createManager()
        let signal = manager.rac_POST(path, parameters: params)
        return signal.map({ (jsonAndHeader) -> AnyObject! in
            guard let tuple = jsonAndHeader as? RACTuple else {
                return jsonAndHeader
            }
            guard let dict = tuple.first as? NSDictionary else {
                return jsonAndHeader
            }
            let comment = Comment(dictionary: dict)
            return comment
        })
    }

    func createIssue(issue: Issue, accountName: String, repoSlug: String) -> RACSignal {
        let params = issue.toParams()
        let path = "repositories/\(accountName)/\(repoSlug)/issues"
        let manager = self.createManager()
        let signal = manager.rac_POST(path, parameters: params as [NSObject : AnyObject])
        return signal.map({ (jsonAndHeader) -> AnyObject! in
            guard let tuple = jsonAndHeader as? RACTuple else {
                return jsonAndHeader
            }
            guard let dict = tuple.first as? NSDictionary else {
                return jsonAndHeader
            }
            let createdIssue = Issue(dictionary: dict)
            return createdIssue
        })
    }

    func updateIssue(issue: Issue, accountName: String, repoSlug: String) -> RACSignal {
        let params = issue.toParams()
        let path = "repositories/\(accountName)/\(repoSlug)/issues/\(issue.localId)"
        let manager = self.createManager()
        let signal = manager.rac_PUT(path, parameters: params as [NSObject : AnyObject])
        return signal.map({ (jsonAndHeader) -> AnyObject! in
            guard let tuple = jsonAndHeader as? RACTuple else {
                return jsonAndHeader
            }
            guard let dict = tuple.first as? NSDictionary else {
                return jsonAndHeader
            }
            let updatedIssue = Issue(dictionary: dict)
            return updatedIssue
        })
    }
}
