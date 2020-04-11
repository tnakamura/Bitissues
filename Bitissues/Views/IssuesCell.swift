//
//  IssuesCell.swift
//  Bitissues
//
//  Created by tnakamura on 2014/09/13.
//  Copyright (c) 2014年 tnakamura. All rights reserved.
//

import UIKit

class IssuesCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var createdOnLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var issueIdLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    /**
     * イシューの内容をセルに表示します。
     *
     * - parameter issue: イシュー
     */
    func setupIssue(issue: Issue) {
        self.titleLabel.text = issue.title
        self.contentLabel.text = issue.content
        self.createdOnLabel.text = (issue.createdOn! as NSString).substringToIndex(10)
        self.issueIdLabel.text = "created #\(issue.localId)"
        if issue.reportedBy != nil {
            self.userLabel.text = issue.reportedBy!.username
            
            if issue.reportedBy!.avatar != nil {
                self.avatarImageView.setImageWithURL(
                    NSURL(string: issue.reportedBy!.avatar!),
                    placeholderImage: Theme.userMenuImage()
                )
            } else {
                self.avatarImageView.image = Theme.userMenuImage()
            }
        }
    }
    
    class func estimatedHeight() -> CGFloat {
        return 110.0
    }
    
    class func heightForIssue(issue: Issue, tableView: UITableView) -> CGFloat {
        let cell = tableView.dequeueReusableCellWithIdentifier("IssuesCell") as! IssuesCell
        cell.setupIssue(issue)
        cell.layoutSubviews()
        let height = cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
        return height
    }
    
    class func cellForIssue(issue: Issue, tableView: UITableView, indexPath: NSIndexPath) -> IssuesCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("IssuesCell",
            forIndexPath: indexPath) as! IssuesCell
        cell.setupIssue(issue)
        return cell
    }
}
