//
//  MenuViewModel.swift
//  Bitissues
//
//  Created by tnakamura on 2014/09/07.
//  Copyright (c) 2014年 tnakamura. All rights reserved.
//

import UIKit

class MenuViewModel: NSObject {
    var manager: AccountManager!
    private var menus: [Menu]
    
    override init() {
        self.menus = [Menu]()
        self.menus.append(Menu(
            title: "Favorites",
            image: Theme.favoriteMenuImage()
        ))
        self.menus.append(Menu(
            title: "Find Repos",
            image: Theme.searchMenuImage()
        ))
    }
    
    func numberOfSections() -> Int {
        return 2
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        switch section {
        case 0:
            return self.menus.count
        case 1:
            if self.isLoggedIn() {
                return 1
            } else {
                return 0
            }
        default:
            return 0
        }
    }
    
    func menuAtIndexPath(indexPath: NSIndexPath) -> Menu? {
        switch indexPath.section {
        case 0:
            return commonMenuAtRow(indexPath.row)
        case 1:
            return privateMenuAtRow(indexPath.row)
        default:
            return nil
        }
    }
    
    private func commonMenuAtRow(row: Int) -> Menu? {
        return self.menus[row]
    }
    
    private func privateMenuAtRow(row: Int) -> Menu? {
        switch row {
        case 0:
            if self.isLoggedIn() {
                let account = self.manager.currentAccount!
                let menu = Menu(account: account)
                return menu
            } else {
                return nil
            }
        default:
            return nil
        }
    }
    
    func isLoggedIn() -> Bool {
        return self.manager.isLoggedIn()
    }
    
    func logout() {
        manager.logout()
    }
}
