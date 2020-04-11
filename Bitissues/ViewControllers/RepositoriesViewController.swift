//
//  RepositoriesViewController.swift
//  Bitissues
//
//  Created by tnakamura on 2014/09/07.
//  Copyright (c) 2014年 tnakamura. All rights reserved.
//

import UIKit

class RepositoriesViewController: UITableViewController, UISearchBarDelegate {
    private var viewModel: RepositoriesViewModel = RepositoriesViewModel()
    
    @IBOutlet weak var repositorySearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewModel.client = BitbucketClient.sharedClient
        
        self.navigationItem.title = self.viewModel.userName
        self.navigationItem.backBarButtonItem = self.backBarButtonItem()
        if let userName = self.viewModel.userName {
            self.repositorySearchBar.placeholder = "Search \(userName) repos"
       
        }
        self.refreshControl?.addTarget(self,
            action: "loadRepositories",
            forControlEvents: UIControlEvents.ValueChanged)

        self.tableView.setContentOffset(
            CGPoint(x: 0, y: -self.refreshControl!.frame.size.height),
            animated: true
        )
        
        self.loadRepositories()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.repositoryCount()
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RepositoryCell", forIndexPath: indexPath) 
        let repository = self.viewModel.repositoryAtIndex(indexPath.row)
        self.configureCell(cell, repository:repository)
        return cell
    }
    
    private func configureCell(cell: UITableViewCell, repository: Repository) {
        cell.textLabel?.text = repository.displayName
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "All Repositories"
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let repository = self.viewModel.repositoryAtIndex(indexPath.row)
        let ctrl = IssuesViewController.createIssuesViewController()
        ctrl.viewModel.repository = repository
        ctrl.viewModel.client = BitbucketClient.sharedClient
        ctrl.viewModel.account = AccountManager.sharedManager.currentAccount
        self.navigationController?.pushViewController(ctrl, animated: true)
    }

    func loadRepositories() {
        self.refreshControl?.beginRefreshing()
        self.viewModel.loadRepositories().subscribeNext({ (repositories: AnyObject!) -> Void in
            self.refreshControl?.endRefreshing()
            self.tableView.reloadData()
            return
        }, error: { (error: NSError!) -> Void in
            self.refreshControl?.attributedTitle = NSAttributedString(
                string: "\(error.localizedDescription)")
            self.refreshControl?.endRefreshing()
            return
        });
    }

    class func createRepositoriesViewController() -> RepositoriesViewController {
        let storyboard = UIStoryboard(name: "Repositories", bundle: nil)
        let viewController = storyboard.instantiateInitialViewController() as! RepositoriesViewController
        return viewController
    }

    // MARK: - Table view data source
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.viewModel.resetFiltering()
        } else {
            self.viewModel.searchText = searchText
            self.viewModel.filterRepositories()
        }
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
