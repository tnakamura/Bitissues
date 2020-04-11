//
//  IssueFormViewController.swift
//  Bitissues
//
//  Created by tnakamura on 2014/09/15.
//  Copyright (c) 2014年 tnakamura. All rights reserved.
//

import UIKit

protocol IssueFormViewControllerDelegate {
    func issueFormViewControllerDidFinished(sender: IssueFormViewController)
}

class IssueFormViewController: UITableViewController, ItemsViewControllerDelegate {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var responsibleLabel: UILabel!
    @IBOutlet weak var kindLabel: UILabel!
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    
    var delegate: IssueFormViewControllerDelegate?
    var viewModel: IssueFormViewModel!

    private var hud: MBProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = self.backBarButtonItem()
        if !self.viewModel.isNew {
            self.navigationItem.title = "Edit Issue #\(self.viewModel.issueId)"
        }
        
        self.titleTextField.text = self.viewModel.title
        self.responsibleLabel.text = self.viewModel.responsible
        self.kindLabel.text = self.viewModel.kind.rawValue
        self.priorityLabel.text = self.viewModel.priority.rawValue
        self.contentTextView.text = self.viewModel.content
        
        self.hud = MBProgressHUD(view: self.view)
        self.view.addSubview(self.hud)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func save(sender: AnyObject) {
        self.viewModel.title = self.titleTextField.text
        self.viewModel.content = self.contentTextView.text
        self.viewModel.responsible = self.responsibleLabel.text
        
        if let newKind = Kind(rawValue: self.kindLabel.text!) {
            self.viewModel.kind = newKind
        }
        
        if let newPriority = Priority(rawValue: self.priorityLabel.text!) {
            self.viewModel.priority = newPriority
        }
        
        self.hud.showWithStatus("Saving issue")
        self.viewModel.saveIssue().subscribeNext({ (response: AnyObject!) -> Void in
            self.hud.showSuccessWithStatus("Saved")
            self.delegate?.issueFormViewControllerDidFinished(self)
            self.dismissViewControllerAnimated(true, completion: nil)
        }, error: { (error: NSError!) -> Void in
            self.hud.showErrorWithStatus("\(error.localizedDescription)")
        })
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 1:
            self.openResponsibles()
            break
        case 2:
            self.openKinds()
            break
        case 3:
            self.openPriorities()
            break
        default:
            break
        }
    }
    
    private func openResponsibles() {
        let vm = ResponsiblesViewModel()
        vm.repository = self.viewModel.repository.clone()
        vm.selectedItem = self.viewModel.responsible
        vm.client = BitbucketClient.sharedClient
        
        let ctrl = ItemsViewController.createItemsViewController()
        ctrl.viewModel = vm
        ctrl.delegate = self
        self.navigationController?.pushViewController(ctrl, animated: true)
    }
    
    private func openKinds() {
        let vm = KindsViewModel()
        vm.selectedItem = self.viewModel.kind.rawValue
        
        let ctrl = ItemsViewController.createItemsViewController()
        ctrl.viewModel = vm
        ctrl.delegate = self
        self.navigationController?.pushViewController(ctrl, animated: true)
    }
    
    private func openPriorities() {
        let vm = PrioritiesViewModel()
        vm.selectedItem = self.viewModel.priority.rawValue
        
        let ctrl = ItemsViewController.createItemsViewController()
        ctrl.viewModel = vm
        ctrl.delegate = self
        self.navigationController?.pushViewController(ctrl, animated: true)
    }
    
    class func createViewControllerWithNavigation() -> UINavigationController {
        let storyboard = UIStoryboard(name: "IssueForm", bundle: nil)
        let ctrl = storyboard.instantiateInitialViewController() as! UINavigationController
        return ctrl
    }

    // MARK: - Table view data source
    
    func itemsViewControllerDidChangeSelection(controller: ItemsViewController, selectedValue: String?) {
        if controller.viewModel is KindsViewModel {
            self.kindLabel.text = selectedValue
            if let newKind = Kind(rawValue: selectedValue!) {
                self.viewModel.kind = newKind
            }
        } else if controller.viewModel is PrioritiesViewModel {
            self.priorityLabel.text = selectedValue
            if let newPriority = Priority(rawValue: selectedValue!) {
                self.viewModel.priority = newPriority
            }
        } else if controller.viewModel is ResponsiblesViewModel {
            self.responsibleLabel.text = selectedValue
            self.viewModel.responsible = selectedValue
        }
    }
}
