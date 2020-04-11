//
//  CommentViewController.swift
//  Bitissues
//
//  Created by tnakamura on 2014/09/15.
//  Copyright (c) 2014年 tnakamura. All rights reserved.
//

import UIKit

protocol CommentViewControllerDelegate {
    func commentViewControllerDidFinished(sender: CommentViewController)
}

class CommentViewController: UIViewController {

    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var postButtonItem: UIBarButtonItem!
    
    var delegate: CommentViewControllerDelegate?
    var viewModel: CommentViewModel = CommentViewModel()

    private var hud: MBProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.backBarButtonItem = self.backBarButtonItem()
        
        self.viewModel.client = BitbucketClient.sharedClient
        self.viewModel.account = AccountManager.sharedManager.currentAccount
        
        self.commentTextView.text = self.viewModel.comment

        // commentTextView.text と viewModel.comment をバインド
        self.commentTextView.rac_textSignal().setKeyPath("comment", onObject: self.viewModel)
        
        // viewModel.comment と postButtonItem.enabled をバインド
        self.viewModel.rac_valuesForKeyPath(
            "comment",
            observer: self.viewModel
        ).map({ (next) -> AnyObject! in
            let newComment = next as! String
            return !newComment.isEmpty
        }).setKeyPath("enabled", onObject: self.postButtonItem)
        
        self.hud = MBProgressHUD(view: self.view)
        self.view.addSubview(self.hud)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func postComment(sender: AnyObject) {
        self.viewModel.comment = self.commentTextView.text
        if self.viewModel.canPostComment() == false {
            return
        }

        self.hud.showWithStatus("Post Comment")
        self.viewModel.postComment().subscribeNext({ (comment) -> Void in
            self.hud.showSuccessWithStatus("Posted Comment")
            self.delegate?.commentViewControllerDidFinished(self)
            self.dismissViewControllerAnimated(true, completion: nil)
        }, error: { (error) -> Void in
            self.hud.showErrorWithStatus("\(error.localizedDescription)")
        })
    }

    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    class func createViewControllerWithNavigation() -> UINavigationController {
        let storyboard = UIStoryboard(name: "Comment", bundle: nil)
        let navi = storyboard.instantiateInitialViewController() as! UINavigationController
        return navi
    }
}

