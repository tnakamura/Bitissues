//
//  MBProgressHUDExtensions.swift
//  Bitissues
//
//  Created by tnakamura on 2014/09/23.
//  Copyright (c) 2014年 tnakamura. All rights reserved.
//

import UIKit

extension MBProgressHUD {
    func showWithStatus(status: String) {
        self.labelText = status
        self.mode = MBProgressHUDMode.Indeterminate
        self.show(true)
    }
    
    func showErrorWithStatus(status: String) {
        let icon = FAKIonIcons.iosCloseIconWithSize(28)
        showWithStatus(status, icon: icon)
    }
    
    func showSuccessWithStatus(status: String) {
        let icon = FAKIonIcons.iosCheckmarkIconWithSize(28)
        showWithStatus(status, icon: icon)
    }
    
    private func showWithStatus(status: String, icon: FAKIcon) {
        icon.addAttribute(NSForegroundColorAttributeName, value: UIColor.whiteColor())
        let image = icon.imageWithSize(CGSize(width: 28, height: 28))
        let imageView = UIImageView(image: image)
        self.labelText = status
        self.mode = MBProgressHUDMode.CustomView
        self.customView = imageView
        self.hide(true, afterDelay: 2.0)
    }
}
