//
//  Theme.swift
//  Bitissues
//
//  Created by tnakamura on 2014/09/17.
//  Copyright (c) 2014年 tnakamura. All rights reserved.
//

class Theme : NSObject {
    // MARK: - Images

    static let iconSize: CGFloat = 25.0

    static let logOutImage: UIImage = {
            let size = Theme.iconSize
            let icon = FAKIonIcons.logOutIconWithSize(size)
            return icon.imageWithSize(CGSize(width: size, height: size))
    }()

    static let logInImage: UIImage = {
            let size = Theme.iconSize
            let icon = FAKIonIcons.logInIconWithSize(size)
            return icon.imageWithSize(CGSize(width: size, height: size))
    }()

    static let newIssueImage: UIImage = {
            let size = Theme.iconSize
            let icon = FAKIonIcons.plusIconWithSize(size)
            return icon.imageWithSize(CGSize(width: size, height: size))
    }()

    static let filterImage: UIImage = {
            let size = Theme.iconSize
            let icon = FAKIonIcons.levelsIconWithSize(size)
            return icon.imageWithSize(CGSize(width: size, height: size))
    }()

    static let favoriteImage: UIImage = {
            let size = Theme.iconSize
            let icon = FAKIonIcons.iosStarIconWithSize(size)
            return icon.imageWithSize(CGSize(width: size, height: size))
    }()

    static let notFavoriteImage: UIImage = {
            let size = Theme.iconSize
            let icon = FAKIonIcons.iosStarOutlineIconWithSize(size)
            return icon.imageWithSize(CGSize(width: size, height: size))
    }()

    static let commentImage: UIImage = {
            let size = Theme.iconSize
            let icon = FAKIonIcons.iosChatbubbleIconWithSize(size)
            return icon.imageWithSize(CGSize(width: size, height: size))
    }()
    
    class func favoriteMenuImage() -> UIImage {
        return menuImageWithIcon({ (size) -> FAKIcon in
            return FAKIonIcons.iosStarIconWithSize(size)
        })
    }
    
    class func searchMenuImage() -> UIImage {
        return menuImageWithIcon({ (size) -> FAKIcon in
            return FAKIonIcons.searchIconWithSize(size)
        })
    }
    
    class func userMenuImage() -> UIImage {
        return menuImageWithIcon({ (size) -> FAKIcon in
            return FAKFontAwesome.userIconWithSize(size)
        })
    }
    
    private class func menuImageWithIcon(iconBlock: (CGFloat -> FAKIcon)) -> UIImage {
        let size = Theme.iconSize
        let color = menuImageColor
        let icon = iconBlock(size)
        icon.addAttribute(NSForegroundColorAttributeName, value: color)
        return icon.imageWithSize(CGSize(width: size, height: size))
    }
    
    private static let menuImageColor: UIColor = {
        return UIColor(
            red: 0.125,
            green: 0.314,
            blue: 0.506,
            alpha: 1.0
        )
    }()
}
