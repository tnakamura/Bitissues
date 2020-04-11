//
//  MenuViewController.swift
//  Bitissues
//
//  Created by tnakamura on 2014/09/07.
//  Copyright (c) 2014年 tnakamura. All rights reserved.
//

import UIKit
import iAd

class MenuViewController: UITableViewController, LoginViewControllerDelegate {
    var viewModel: MenuViewModel!
    
    var logoutButton: UIBarButtonItem {
        let logoutButton = UIBarButtonItem(
            image: Theme.logOutImage,
            style: UIBarButtonItemStyle.Plain,
            target: self,
            action: "logout:"
        )
        return logoutButton
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.navigationItem.title = "Bitissues"
        self.navigationItem.backBarButtonItem = self.backBarButtonItem()
        self.navigationItem.rightBarButtonItem = self.logoutButton
        self.canDisplayBannerAds = true
        
        self.viewModel = self.createViewModel()
        
        self.viewModel.manager!.loadAccount()
        if self.viewModel.isLoggedIn() == false {
            self.showLoginForm()
        } else {
            let account = self.viewModel.manager!.currentAccount!
            BitbucketClient.sharedClient.username = account.name
            BitbucketClient.sharedClient.password = account.password
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setToolbarHidden(true, animated: false)
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setToolbarHidden(true, animated: false)
    }
    
    func createViewModel() -> MenuViewModel {
        let vm = MenuViewModel()
        vm.manager = AccountManager.sharedManager
        return vm
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.viewModel.numberOfSections()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRowsInSection(section)
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) 

        // Configure the cell...
        let menu = self.viewModel.menuAtIndexPath(indexPath)
        if menu != nil {
            configureCell(cell, menu: menu!)
        }
        return cell
    }
    
    private func configureCell(cell: UITableViewCell, menu: Menu) {
        cell.textLabel?.text = menu.title
        if menu.image != nil {
            cell.imageView?.image = menu.image
        } else if menu.imageUrl != nil {
            cell.imageView?.setImageWithURL(
                NSURL(string: menu.imageUrl!),
                placeholderImage: Theme.userMenuImage()
            )
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let ctrl = FavoritesViewController.createFavoritesViewController()
                self.navigationController?.pushViewController(ctrl, animated: true)
                break
            case 1:
                let ctrl = SearchViewController.createSearchViewController()
                self.navigationController?.pushViewController(ctrl, animated: true)
                break
            default:
                break
            }
            break
        case 1:
            switch indexPath.row {
            case 0:
                let ctrl = RepositoriesViewController.createRepositoriesViewController()
                self.navigationController?.pushViewController(ctrl, animated: true)
                break
            default:
                break
            }
            break
        default:
            break
        }
    }

    func loginViewControllerDidFinished(sender: LoginViewController) {
        self.tableView.reloadData()
    }
    
    func logout(sender: UIBarButtonItem) {
        let alert = UIAlertController(
            title: "",
            message: "Are you sure you want to logout?",
            preferredStyle: UIAlertControllerStyle.Alert
        )
        alert.addAction(UIAlertAction(
            title: "Cancel",
            style: UIAlertActionStyle.Cancel,
            handler: { (action) -> Void in
            }
        ))
        alert.addAction(UIAlertAction(
            title: "Yes",
            style: UIAlertActionStyle.Default,
            handler: { (action) -> Void in
                self.viewModel.logout()
                self.showLoginForm()
            }
        ))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    private func showLoginForm() {
        let navi = LoginViewController.createLoginViewControllerWithNavigation()
        self.presentViewController(navi, animated: true, completion: nil)
    }
}
