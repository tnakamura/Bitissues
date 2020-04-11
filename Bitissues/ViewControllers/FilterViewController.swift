//
//  FilterViewController.swift
//  Bitissues
//
//  Created by tnakamura on 2014/09/21.
//  Copyright (c) 2014年 tnakamura. All rights reserved.
//

import UIKit

protocol FilterViewControllerDelegate {
    func filterViewControllerDidFinish(controller: FilterViewController)
}

class FilterViewController: UITableViewController, ItemsViewControllerDelegate {

    @IBOutlet weak var responsibleLabel: UILabel!
    @IBOutlet weak var kindLabel: UILabel!
    @IBOutlet weak var priorityLabel: UILabel!
    @IBOutlet weak var statusSegmentedControl: UISegmentedControl!
    @IBOutlet weak var sortSegmentedControl: UISegmentedControl!
    
    var viewModel: FilterViewModel!
    var delegate: FilterViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.backBarButtonItem = self.backBarButtonItem()
        
        self.responsibleLabel.text = self.viewModel.responsible
        self.kindLabel.text = self.viewModel.kind?.rawValue
        self.priorityLabel.text = self.viewModel.priority?.rawValue
        if self.viewModel.isOpen {
            self.statusSegmentedControl.selectedSegmentIndex = 0
        } else {
            self.statusSegmentedControl.selectedSegmentIndex = 1
        }
        switch self.viewModel.sort {
        case FilterSort.CreatedOnAsc:
            self.sortSegmentedControl.selectedSegmentIndex = 0
            break
        case FilterSort.CreatedOnDesc:
            self.sortSegmentedControl.selectedSegmentIndex = 1
            break
        case FilterSort.UpdatedOnAsc:
            self.sortSegmentedControl.selectedSegmentIndex = 2
            break
        case FilterSort.UpdatedOnDesc:
            self.sortSegmentedControl.selectedSegmentIndex = 3
            break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
        case 0:
            self.openResponsibles()
            break
        case 1:
            self.openKinds()
            break
        case 2:
            self.openPriorities()
            break
        default:
            break
        }
    }
    
    private func openResponsibles() {
        let vm = ResponsiblesViewModel()
        vm.selectedItem = self.viewModel.responsible
        vm.repository = self.viewModel.repository?.clone()
        vm.client = BitbucketClient.sharedClient
        
        let ctrl = ItemsViewController.createItemsViewController()
        ctrl.viewModel = vm
        ctrl.delegate = self
        self.navigationController?.pushViewController(ctrl, animated: true)
    }
    
    private func openKinds() {
        let vm = KindsViewModel()
        vm.selectedItem = self.viewModel.kind?.rawValue
        
        let ctrl = ItemsViewController.createItemsViewController()
        ctrl.viewModel = vm
        ctrl.delegate = self
        self.navigationController?.pushViewController(ctrl, animated: true)
    }
    
    private func openPriorities() {
        let vm = PrioritiesViewModel()
        vm.selectedItem = self.viewModel.priority?.rawValue
        
        let ctrl = ItemsViewController.createItemsViewController()
        ctrl.viewModel = vm
        ctrl.delegate = self
        self.navigationController?.pushViewController(ctrl, animated: true)
    }
    
    @IBAction func onClose(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onApply(sender: AnyObject) {
        self.viewModel.responsible = self.responsibleLabel.text
        
        if let newKind = self.kindLabel?.text {
            self.viewModel.kind = Kind(rawValue: newKind)
        }
        
        if let newPriority = self.priorityLabel?.text {
            self.viewModel.priority = Priority(rawValue: newPriority)
        }
        
        self.viewModel.isOpen = self.statusSegmentedControl.selectedSegmentIndex == 0
        
        switch self.sortSegmentedControl.selectedSegmentIndex {
        case 0:
            self.viewModel.sort = FilterSort.CreatedOnAsc
            break
        case 1:
            self.viewModel.sort = FilterSort.CreatedOnDesc
            break
        case 2:
            self.viewModel.sort = FilterSort.UpdatedOnAsc
            break
        case 3:
            self.viewModel.sort = FilterSort.UpdatedOnDesc
            break
        default:
            break
        }
        
        self.delegate?.filterViewControllerDidFinish(self)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Table view data source

    class func createFilterViewControllerWithNavigation() -> UINavigationController {
        let storyboard = UIStoryboard(name: "Filter", bundle: nil)
        let navi = storyboard.instantiateInitialViewController() as! UINavigationController
        return navi
    }

    // MARK: - ItemsViewControllerDelegate
    
    func itemsViewControllerDidChangeSelection(controller: ItemsViewController, selectedValue: String?) {
        if controller.viewModel is KindsViewModel {
            self.kindLabel.text = selectedValue
            if let newKind = selectedValue {
                self.viewModel.kind = Kind(rawValue: newKind)
            } else {
                self.viewModel.kind = nil
            }
        } else if controller.viewModel is PrioritiesViewModel {
            self.priorityLabel.text = selectedValue
            if let newPriority = selectedValue {
                self.viewModel.priority = Priority(rawValue: newPriority)
            } else {
                self.viewModel.priority = nil
            }
        } else if controller.viewModel is ResponsiblesViewModel {
            self.responsibleLabel.text = selectedValue
            self.viewModel.responsible = selectedValue
        }
    }
}
