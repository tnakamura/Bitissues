//
//  Models.swift
//  Bitissues
//
//  Created by tnakamura on 2014/09/19.
//  Copyright (c) 2014年 tnakamura. All rights reserved.
//

import Foundation
import CoreData

extension Favorite {
    var displayName: String {
        return "\(self.owner)/\(self.name)"
    }
    
    func toRepository() -> Repository {
        let repository = Repository()
        repository.name = self.name
        repository.slug = self.slug
        repository.owner = self.owner
        return repository
    }
    
    class func fetchAllWithLogin(login: String, delegate: NSFetchedResultsControllerDelegate?) -> NSFetchedResultsController {
        let predicate = NSPredicate(format: "login = %@", login)
        return Favorite.MR_fetchAllSortedBy(
            "order",
            ascending: true,
            withPredicate: predicate,
            groupBy: nil,
            delegate: delegate
        )
    }
    
    class func findWithLogin(login: String, owner: String, repoSlug: String) -> RACSignal {
        return RACSignal.createSignal({ (subscriber) -> RACDisposable! in
            let context = NSManagedObjectContext.MR_context()
            context.performBlock({ () -> Void in
                let predicate = NSPredicate(
                    format: "login = %@ AND owner = %@ AND slug = %@",
                    login,
                    owner,
                    repoSlug
                )
                let favorite = Favorite.MR_findFirstWithPredicate(predicate, inContext: context)
                if favorite != nil {
                    dispatch_async_main({ () -> () in
                        subscriber.sendNext(favorite)
                        subscriber.sendCompleted()
                    })
                }
            })
            return nil
        })
    }
    
    class func createAsync(login: String, repository: Repository) -> RACSignal {
        var favorite: Favorite? = nil
        return RACSignal.createSignal({ (subscriber) -> RACDisposable! in
            MagicalRecord.saveWithBlock({ (context) -> Void in
                favorite = Favorite.MR_createEntityInContext(context)
                favorite!.name = repository.name!
                favorite!.owner = repository.owner!
                favorite!.slug = repository.slug!
                favorite!.login = login
                favorite!.createdAt = NSDate()
                favorite!.updatedAt = NSDate()
            }, completion: { (success, error) -> Void in
                if success {
                    subscriber.sendNext(favorite!)
                    subscriber.sendCompleted()
                } else {
                    subscriber.sendError(error)
                }
            })
            return nil
        })
    }
    
    func destroyAsync() -> RACSignal {
        return RACSignal.createSignal({ (subscriber) -> RACDisposable! in
            MagicalRecord.saveWithBlock({ (context) -> Void in
                let target = context.objectWithID(self.objectID)
                context.deleteObject(target)
            }, completion: { (success, error) -> Void in
                if success {
                    subscriber.sendNext(success)
                    subscriber.sendCompleted()
                } else {
                    subscriber.sendError(error)
                }
            })
            return nil
        })
    }
}
