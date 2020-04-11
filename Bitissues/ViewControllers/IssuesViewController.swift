//
//  IssuesViewController.swift
//  Bitissues
//
//  Created by tnakamura on 2014/09/07.
//  Copyright (c) 2014年 tnakamura. All rights reserved.
//

import UIKit

class IssuesViewController: UITableViewController, UISearchBarDelegate, IssueFormViewControllerDelegate, FilterViewControllerDelegate {
    var viewModel: IssuesViewModel = IssuesViewModel()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    private var _addButtonItem: UIBarButtonItem?
    
    var addButtonItem: UIBarButtonItem {
        if _addButtonItem == nil {
            let button = UIBarButtonItem(
                image: Theme.newIssueImage,
                style: UIBarButtonItemStyle.Plain,
                target: self,
                action: "newIssue"
            )
            _addButtonItem = button
        }
        return _addButtonItem!
    }
    
    func newIssue() {
        let vm = IssueFormViewModel(repository: self.viewModel.repository!)
        vm.client = BitbucketClient.sharedClient
        
        let ctrl = IssueFormViewController.createViewControllerWithNavigation()
        let form = ctrl.viewControllers[0] as! IssueFormViewController
        form.delegate = self
        form.viewModel = vm
        self.presentViewController(ctrl, animated: true, completion: nil)
    }
    
    private var _filterButtonItem: UIBarButtonItem?
    
    var filterButtonItem: UIBarButtonItem {
        if _filterButtonItem == nil {
            let button = UIBarButtonItem(
                image: Theme.filterImage,
                style: UIBarButtonItemStyle.Plain,
                target: self,
                action: "openFilter"
            )
            _filterButtonItem = button
        }
        return _filterButtonItem!
    }
    
    func openFilter() {
        let vm = FilterViewModel(filter: self.viewModel.filter)
        vm.repository = self.viewModel.repository?.clone()
        
        let navi = FilterViewController.createFilterViewControllerWithNavigation()
        navi.modalTransitionStyle = UIModalTransitionStyle.FlipHorizontal
        let ctrl = navi.viewControllers[0] as! FilterViewController
        ctrl.viewModel = vm
        ctrl.delegate = self
        self.presentViewController(navi, animated: true, completion: nil)
    }
    
    private var _favoriteButtonItem: UIBarButtonItem?
    
    var favoriteButtonItem: UIBarButtonItem {
        if self._favoriteButtonItem == nil {
            let button = UIBarButtonItem(
                image: Theme.notFavoriteImage,
                style: UIBarButtonItemStyle.Plain,
                target: self,
                action: "favoriteRepository"
            )
            self._favoriteButtonItem = button
        }
        return self._favoriteButtonItem!
    }
    
    func favoriteRepository() {
        self.viewModel.createFavorite().subscribeNext({ (response) -> Void in
            self.navigationItem.rightBarButtonItem = self.unfavoriteButtonItem
        }, error: { (error) -> Void in
        })
    }
    
    private  var _unfavoriteButtonItem: UIBarButtonItem?
    
    var unfavoriteButtonItem: UIBarButtonItem {
        if _unfavoriteButtonItem == nil {
            let button = UIBarButtonItem(
                image: Theme.favoriteImage,
                style: UIBarButtonItemStyle.Plain,
                target: self,
                action: "unfavoriteRepository"
            )
            _unfavoriteButtonItem = button
        }
        return _unfavoriteButtonItem!
    }
    
    func unfavoriteRepository() {
        self.viewModel.deleteFavorite().subscribeNext({ (response) -> Void in
            self.navigationItem.rightBarButtonItem = self.favoriteButtonItem
        }, error: { (error) -> Void in
        })
    }

    private var _footerIndicator: UIActivityIndicatorView!

    var footerIndicator: UIActivityIndicatorView {
        if _footerIndicator == nil {
            _footerIndicator = UIActivityIndicatorView(activityIndicatorStyle:UIActivityIndicatorViewStyle.Gray)
        }
        return _footerIndicator
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = self.viewModel.repository?.name
        self.navigationItem.rightBarButtonItem = self.favoriteButtonItem
        self.navigationItem.backBarButtonItem = self.backBarButtonItem()
        
        self.refreshControl?.addTarget(self,
            action: "loadIssues",
            forControlEvents: UIControlEvents.ValueChanged)
        
        self.setToolbarItems([
            self.addButtonItem,
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil),
            self.filterButtonItem
        ], animated: true)
        
        self.tableView.setContentOffset(
            CGPoint(x: 0, y: -self.refreshControl!.frame.size.height),
            animated: true
        )

        // 検索バーが空でも検索できるようにする
        let textField = findSearchBarTextField(self.searchBar)
        if textField != nil {
            textField!.enablesReturnKeyAutomatically = false
        }
        
        self.loadIssues()
        self.loadFavorite()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setToolbarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setToolbarHidden(true, animated: animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func findSearchBarTextField(view: UIView) -> UITextField? {
        for subview in view.subviews {
            if subview is UITextField {
                return subview as? UITextField
            } else if 0 < subview.subviews.count {
                let textField = findSearchBarTextField(subview )
                if textField != nil {
                    return textField
                }
            }
        }
        return nil
    }

    // MARK: - Table view data source

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.issueCount()
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let issue = self.viewModel.issueAtIndex(indexPath.row)
        return IssuesCell.cellForIssue(issue, tableView: tableView, indexPath: indexPath)
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.viewModel.filter?.toPrompt()
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let issue = self.viewModel.issueAtIndex(indexPath.row)
        let vm = IssueViewModel(repository: self.viewModel.repository!, issue: issue)
        vm.client = BitbucketClient.sharedClient
        vm.account = AccountManager.sharedManager.currentAccount
        let ctrl = IssueViewController.createIssueViewController()
        ctrl.viewModel = vm
        self.navigationController?.pushViewController(ctrl, animated: true)
    }

    // 末尾付近にきたら次のイシューを読み込む
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if !self.viewModel.isUpdating && self.viewModel.hasNextPage && (self.viewModel.issueCount() - 5) <= indexPath.row {
            self.loadNextIssues()
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.viewModel.searchText = searchBar.text
        self.loadIssues()
    }

    // MARK: - FilterViewControllerDelegate

    func filterViewControllerDidFinish(controller: FilterViewController) {
        let filter = controller.viewModel!.apply()
        self.viewModel.filter = filter
        self.loadIssues()
    }

    func loadIssues() {
        self.refreshControl?.beginRefreshing()
        self.viewModel.loadIssues().subscribeNext({ (issues: AnyObject!) -> Void in
            self.refreshControl?.endRefreshing()
            self.tableView.reloadData()
            return
        }, error: { (error: NSError!) -> Void in
            self.refreshControl?.attributedTitle = NSAttributedString(
                string: "\(error.localizedDescription)")
            self.refreshControl?.endRefreshing()
            return
        })
    }

    private func loadNextIssues() {
        self.tableView.tableFooterView = self.footerIndicator
        self.footerIndicator.startAnimating()

        self.viewModel.loadNextIssues().subscribeNext({ (issues: AnyObject!) -> Void in
            self.footerIndicator.stopAnimating()
            self.tableView.tableFooterView = nil

            self.tableView.reloadData()
        }, error: { (error: NSError!) -> Void in
        })
    }
    
    private func loadFavorite() {
        self.viewModel.loadFavorite().subscribeNext({ (response: AnyObject!) -> Void in
            if self.viewModel.favorite != nil {
                self.navigationItem.rightBarButtonItem = self.unfavoriteButtonItem
            } else {
                self.navigationItem.rightBarButtonItem = self.favoriteButtonItem
            }
            return
        }, error: { (error: NSError!) -> Void in
        })
    }

    class func createIssuesViewController() -> IssuesViewController {
        let storyboard = UIStoryboard(name: "Issues", bundle: nil)
        let ctrl = storyboard.instantiateInitialViewController() as! IssuesViewController
        return ctrl
    }

    // MARK: - IssueFormViewControllerDelegate

    func issueFormViewControllerDidFinished(sender: IssueFormViewController) {
        self.loadIssues()
    }
}
