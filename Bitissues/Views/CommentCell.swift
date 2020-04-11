//
//  CommentCell.swift
//  Bitissues
//
//  Created by tnakamura on 2014/09/14.
//  Copyright (c) 2014年 tnakamura. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var createdOnLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setupCell(comment: Comment) {
        self.userLabel.text = comment.authorInfo?.username
        self.contentLabel.text = comment.content

        if comment.authorInfo != nil && comment.authorInfo!.avatar != nil {
            self.avatarImageView.setImageWithURL(
                NSURL(string: comment.authorInfo!.avatar!),
                placeholderImage: Theme.userMenuImage()
            )
        } else {
            self.avatarImageView.image = Theme.userMenuImage()
        }
    }
    
    class func estimatedHeight() -> CGFloat {
        return 110.0
    }
    
    class func heightForComment(comment: Comment, tableView: UITableView) -> CGFloat {
        let cell = tableView.dequeueReusableCellWithIdentifier("CommentCell") as! CommentCell
        cell.setupCell(comment)
        cell.layoutSubviews()
        return cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
    }
    
    class func cellForComment(comment: Comment, tableView: UITableView, indexPath: NSIndexPath) -> CommentCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CommentCell",
            forIndexPath: indexPath) as! CommentCell
        cell.setupCell(comment)
        return cell
    }
}
