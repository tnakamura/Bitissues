//
//  FavoritesViewModel.swift
//  Bitissues
//
//  Created by tnakamura on 2014/09/16.
//  Copyright (c) 2014年 tnakamura. All rights reserved.
//

import UIKit
import CoreData

class FavoritesViewModel: NSObject {
    var account: Account!
    var delegate: NSFetchedResultsControllerDelegate?
    private var _fetchedResultsController: NSFetchedResultsController?

    private var fetchedResultsController: NSFetchedResultsController {
        get {
            if _fetchedResultsController == nil {
                self._fetchedResultsController = self.createController()
            }
            return self._fetchedResultsController!
        }
    }

    private func createController() -> NSFetchedResultsController {
        return Favorite.fetchAllWithLogin(
            self.account.name,
            delegate: self.delegate
        )
    }

    func favoriteCount() -> Int {
        if let section = self.fetchedResultsController.sections?[0] {
            return section.numberOfObjects
        } else {
            return 0
        }
    }

    func favoriteAtIndex(index: Int) -> Favorite {
        let indexPath = NSIndexPath(forRow: index, inSection: 0)
        let favorite = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Favorite
        return favorite
    }
}

