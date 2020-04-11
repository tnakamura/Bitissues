//
//  IssueViewController.swift
//  Bitissues
//
//  Created by tnakamura on 2014/09/07.
//  Copyright (c) 2014年 tnakamura. All rights reserved.
//

import UIKit

class IssueViewController: UITableViewController, IssueFormViewControllerDelegate, CommentViewControllerDelegate {
    var viewModel: IssueViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "Issue #\(self.viewModel.issueId)"
        self.navigationItem.rightBarButtonItem = self.editIssueButtonItem
        self.navigationItem.backBarButtonItem = self.backBarButtonItem()
        
        self.setToolbarItems([self.commentButtonItem], animated: true)
        self.refreshControl?.addTarget(self,
            action: "loadComments",
            forControlEvents: UIControlEvents.ValueChanged)
        
        self.loadComments()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.setToolbarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setToolbarHidden(true, animated: animated)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 4
        case 1:
            return 1
        case 2:
            return self.viewModel.commentCount()
        default:
            return 0
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            return getIssueHeaderCell(indexPath)
        case 1:
            return IssueCell.cellForIssue(self.viewModel.issue, tableView: tableView, indexPath: indexPath)
        case 2:
            let comment = self.viewModel.commentAtIndex(indexPath.row)
            return CommentCell.cellForComment(comment, tableView: tableView, indexPath: indexPath)
        default:
            return tableView.dequeueReusableCellWithIdentifier(
                "CommonCell", forIndexPath: indexPath) 
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    override func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    private func getIssueHeaderCell(indexPath: NSIndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCellWithIdentifier(
        "CommonCell", forIndexPath: indexPath) 
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = "Responsible"
            cell.detailTextLabel?.text = self.viewModel?.responsible
            break
        case 1:
            cell.textLabel?.text = "Status"
            cell.detailTextLabel?.text = self.viewModel?.status.rawValue
            break
        case 2:
            cell.textLabel?.text = "Kind"
            cell.detailTextLabel?.text = self.viewModel?.kind.rawValue
            break
        case 3:
            cell.textLabel?.text = "Priority"
            cell.detailTextLabel?.text = self.viewModel?.priority.rawValue
            break
        default:
            break
        }
        
        return cell
    }
    
    func loadComments() {
        self.refreshControl?.beginRefreshing()
        self.viewModel.loadComments().subscribeNext({ (comments: AnyObject!) -> Void in
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
            return
        }, error: { (error: NSError!) -> Void in
            self.refreshControl?.attributedTitle = NSAttributedString(
                string: "\(error.localizedDescription)")
            self.refreshControl?.endRefreshing()
            return
        })
    }

    func loadIssue() {
        self.refreshControl?.beginRefreshing()
        self.viewModel.loadIssue().subscribeNext({ (response: AnyObject!) -> Void in
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
            return
        }, error: { (error: NSError!) -> Void in
            self.refreshControl?.attributedTitle = NSAttributedString(
                string: "\(error.localizedDescription)")
            self.refreshControl?.endRefreshing()
            return
        })
    }

    private var _commentButtonItem: UIBarButtonItem! = nil
    
    var commentButtonItem: UIBarButtonItem {
        if _commentButtonItem == nil {
            let button = UIBarButtonItem(
                image: Theme.commentImage,
                style: UIBarButtonItemStyle.Plain,
                target: self,
                action: "openCommentForm"
            )
            _commentButtonItem = button
        }
        return _commentButtonItem
    }

    func openCommentForm() {
        let navi = CommentViewController.createViewControllerWithNavigation()
        let ctrl = navi.viewControllers[0] as! CommentViewController
        ctrl.delegate = self
        ctrl.viewModel.issue = self.viewModel.issue.clone()
        ctrl.viewModel.repository = self.viewModel.repository.clone()
        self.presentViewController(navi, animated: true, completion: nil)
    }

    private var _editIssueButtonItem: UIBarButtonItem! = nil
    
    var editIssueButtonItem: UIBarButtonItem {
        if _editIssueButtonItem == nil {
            let button = UIBarButtonItem(
                barButtonSystemItem: UIBarButtonSystemItem.Compose,
                target: self,
                action: "editIssue"
            )
            _editIssueButtonItem = button
        }
        return _editIssueButtonItem
    }
    
    func editIssue() {
        let vm = IssueFormViewModel(
            repository: self.viewModel.repository,
            issue: self.viewModel.issue
        )
        vm.client = BitbucketClient.sharedClient
        
        let ctrl = IssueFormViewController.createViewControllerWithNavigation()
        let form = ctrl.viewControllers[0] as! IssueFormViewController
        form.delegate = self
        form.viewModel = vm
        self.presentViewController(ctrl, animated: true, completion: nil)
    }

    class func createIssueViewController() -> IssueViewController {
        let storyboard = UIStoryboard(name: "Issue", bundle: nil)
        let ctrl = storyboard.instantiateInitialViewController() as! IssueViewController
        return ctrl
    }

    // MARK: - CommentViewControllerDelegate

    func commentViewControllerDidFinished(sender: CommentViewController) {
        self.loadComments()
    }

    // MARK: - IssueFormViewControllerDelegate

    func issueFormViewControllerDidFinished(sender: IssueFormViewController) {
        self.loadIssue()
    }
}
