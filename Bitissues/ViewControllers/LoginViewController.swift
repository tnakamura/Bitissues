//
//  LoginViewController.swift
//  Bitissues
//
//  Created by tnakamura on 2014/09/08.
//  Copyright (c) 2014年 tnakamura. All rights reserved.
//

import UIKit

protocol LoginViewControllerDelegate {
    func loginViewControllerDidFinished(sender: LoginViewController)
}

class LoginViewController: UITableViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var viewModel: LoginViewModel!
    var delegate: LoginViewControllerDelegate?
    private var hud: MBProgressHUD!
    
    private var loginButton_: UIBarButtonItem?
    
    var loginButton: UIBarButtonItem {
        if self.loginButton_ == nil {
            let button = UIBarButtonItem(
                image: Theme.logInImage,
                style: UIBarButtonItemStyle.Plain,
                target: self,
                action: "login:"
            )
            button.enabled = false
            self.loginButton_ = button
        }
        return self.loginButton_!
    }
    
    func login(sender: UIBarButtonItem) {
        self.hud.showWithStatus("Logging In")
        self.viewModel.login().subscribeNext({ (user) -> Void in
            self.hud.hide(true)
            self.dismissViewControllerAnimated(true, completion: nil)
            self.delegate?.loginViewControllerDidFinished(self)
        }, error: { (error) -> Void in
            self.hud.showErrorWithStatus(error.localizedDescription)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = self.loginButton
        self.navigationItem.backBarButtonItem = self.backBarButtonItem()
        
        self.hud = MBProgressHUD(view: self.view)
        self.view.addSubview(self.hud)
        
        self.viewModel = self.createViewModel()
        
        self.usernameTextField.rac_textSignal().subscribeNext { (username) -> Void in
            self.viewModel.username = username as! String?
            self.loginButton.enabled = self.viewModel.isValid()
        }
        self.passwordTextField.rac_textSignal().subscribeNext { (password) -> Void in
            self.viewModel.password = password as! String?
            self.loginButton.enabled = self.viewModel.isValid()
        }
    }

    private func createViewModel() -> LoginViewModel {
        let vm = LoginViewModel()
        vm.manager = AccountManager.sharedManager
        vm.client = BitbucketClient.sharedClient
        return vm
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
 
    class func createLoginViewControllerWithNavigation() -> UINavigationController {
        let storyboard = UIStoryboard(name: "Login", bundle: nil)
        let ctrl = storyboard.instantiateInitialViewController() as! UINavigationController
        return ctrl
    }
}
