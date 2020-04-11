//
//  SearchViewController.swift
//  Bitissues
//
//  Created by tnakamura on 2014/09/07.
//  Copyright (c) 2014年 tnakamura. All rights reserved.
//

import UIKit

class SearchViewController: UITableViewController, UISearchBarDelegate {
    var viewModel: SearchViewModel!
    private var hud: MBProgressHUD!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Search repos"
        self.navigationItem.backBarButtonItem = self.backBarButtonItem()
        
        self.viewModel = SearchViewModel()
        self.viewModel.client = BitbucketClient.sharedClient

        self.hud = MBProgressHUD(view: self.view)
        self.view.addSubview(self.hud)
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
        return self.viewModel.repositoryCount()
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RepositoryCell",
            forIndexPath: indexPath) 
        self.configureCell(cell, indexPath: indexPath)
        return cell
    }

    private func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        let repository = self.viewModel.repositoryAtIndex(indexPath.row)
        cell.textLabel?.text = repository.displayName
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let repository = self.viewModel.repositoryAtIndex(indexPath.row)
        let ctrl = IssuesViewController.createIssuesViewController()
        ctrl.viewModel.repository = repository
        ctrl.viewModel.client = BitbucketClient.sharedClient
        ctrl.viewModel.account = AccountManager.sharedManager.currentAccount
        self.navigationController?.pushViewController(ctrl, animated: true)
    }

    class func createSearchViewController() -> SearchViewController {
        let storyboard = UIStoryboard(name: "Search", bundle: nil)
        let ctrl = storyboard.instantiateInitialViewController() as! SearchViewController
        return ctrl
    }

    // MARK: - UISearchBar delegate

    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()

        self.viewModel.keyword = searchBar.text
        self.hud.showWithStatus("Searching")
        self.viewModel.search().subscribeNext({ (repositories: AnyObject!) -> Void in
            self.hud.hide(true)
            self.tableView.reloadData()
        }, error: { (error: NSError!) -> Void in
            self.hud.showErrorWithStatus("\(error.localizedDescription)")
        })
    }
}
