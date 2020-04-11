//
//  ItemsViewController.swift
//  Bitissues
//
//  Created by tnakamura on 2014/09/17.
//  Copyright (c) 2014年 tnakamura. All rights reserved.
//

import UIKit

protocol ItemsViewControllerDelegate {
    func itemsViewControllerDidChangeSelection(controller: ItemsViewController, selectedValue: String?)
}

class ItemsViewController: UITableViewController {
    var viewModel: ItemsViewModel!
    var delegate: ItemsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = self.viewModel.title
        self.navigationItem.backBarButtonItem = self.backBarButtonItem()
        self.refreshControl?.addTarget(self,
            action: "loadItems",
            forControlEvents: UIControlEvents.ValueChanged)

        self.loadItems()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.itemCount()
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell",
            forIndexPath: indexPath) 
        self.configureCell(cell, indexPath: indexPath)
        return cell
    }
    
    private func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        let item = self.viewModel.itemAtIndex(indexPath.row)
        cell.textLabel?.text = item
        if item == self.viewModel.selectedItem {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = self.viewModel.itemAtIndex(indexPath.row)
        if self.viewModel.selectedItem == item {
            self.viewModel.selectedItem = nil
            self.delegate?.itemsViewControllerDidChangeSelection(self, selectedValue: nil)
        } else {
            self.viewModel.selectedItem = item
            self.delegate?.itemsViewControllerDidChangeSelection(self, selectedValue: item)
        }
        self.tableView.reloadData()
    }

    func loadItems() {
        self.refreshControl?.beginRefreshing()
        
        _ = self.viewModel.loadItems().subscribeNext({ (next: AnyObject!) -> Void in
            self.refreshControl?.endRefreshing()
            self.tableView.reloadData()
            return
        }, error: { (error: NSError!) -> Void in
            self.refreshControl?.attributedTitle = NSAttributedString(
                string: "\(error.localizedDescription))")
            self.refreshControl?.endRefreshing()
            return
        });
    }

    class func createItemsViewController() -> ItemsViewController {
        let storyboard = UIStoryboard(name: "Items", bundle: nil)
        let ctrl = storyboard.instantiateInitialViewController() as! ItemsViewController
        return ctrl
    }
}
