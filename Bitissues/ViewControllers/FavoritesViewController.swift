//
//  FavoritesViewController.swift
//  Bitissues
//
//  Created by tnakamura on 2014/09/07.
//  Copyright (c) 2014年 tnakamura. All rights reserved.
//

import UIKit

class FavoritesViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    var viewModel: FavoritesViewModel = FavoritesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Favorites"
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.navigationItem.backBarButtonItem = self.backBarButtonItem()
        
        self.viewModel.delegate = self
        self.viewModel.account = AccountManager.sharedManager.currentAccount
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.favoriteCount()
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FavoriteCell", forIndexPath: indexPath) 
        self.configureCell(cell, indexPath: indexPath)
        return cell
    }
    
    private func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        let favorite = self.viewModel.favoriteAtIndex(indexPath.row)
        cell.textLabel?.text = favorite.displayName
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let favorite = self.viewModel.favoriteAtIndex(indexPath.row)
        let repository = favorite.toRepository()
        let vm = IssuesViewModel()
        vm.repository = repository
        vm.client = BitbucketClient.sharedClient
        vm.account = AccountManager.sharedManager.currentAccount
        let ctrl = IssuesViewController.createIssuesViewController()
        ctrl.viewModel = vm
        self.navigationController?.pushViewController(ctrl, animated: true)
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let favorite = self.viewModel.favoriteAtIndex(indexPath.row)
            favorite.MR_deleteEntity()
            favorite.managedObjectContext?.MR_saveToPersistentStoreWithCompletion(nil)
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView!, moveRowAtIndexPath fromIndexPath: NSIndexPath!, toIndexPath: NSIndexPath!) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView!, canMoveRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controller(controller: NSFetchedResultsController,
        didChangeObject anObject: AnyObject,
        atIndexPath indexPath: NSIndexPath?,
        forChangeType type: NSFetchedResultsChangeType,
        newIndexPath: NSIndexPath?) {
            if type == NSFetchedResultsChangeType.Insert {
                self.tableView.insertRowsAtIndexPaths([newIndexPath!],
                    withRowAnimation: UITableViewRowAnimation.Fade)
            } else if type == NSFetchedResultsChangeType.Update {
                self.tableView.reloadRowsAtIndexPaths([newIndexPath!],
                    withRowAnimation:UITableViewRowAnimation.Fade)
            } else if type == NSFetchedResultsChangeType.Delete {
                self.tableView.deleteRowsAtIndexPaths([indexPath!],
                    withRowAnimation:UITableViewRowAnimation.Fade)
            } else if type == NSFetchedResultsChangeType.Move {
                self.tableView.deleteRowsAtIndexPaths([indexPath!],
                    withRowAnimation:UITableViewRowAnimation.Fade)
                self.tableView.insertRowsAtIndexPaths([newIndexPath!],
                    withRowAnimation:UITableViewRowAnimation.Fade)
            }
    }

    class func createFavoritesViewController() -> FavoritesViewController {
        let storyboard = UIStoryboard(name: "Favorites", bundle: nil)
        let ctrl = storyboard.instantiateInitialViewController() as! FavoritesViewController
        return ctrl
    }
}
