//
//  IssueCell.swift
//  Bitissues
//
//  Created by tnakamura on 2014/09/15.
//  Copyright (c) 2014年 tnakamura. All rights reserved.
//

import UIKit

class IssueCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var issueIdLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
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

    func setupCell(issue: Issue) {
        self.titleLabel.text = issue.title
        self.contentLabel.text = issue.content
        self.issueIdLabel.text = "created #\(issue.localId)"
        self.userLabel.text = issue.reportedBy?.username
        if issue.reportedBy != nil && issue.reportedBy!.avatar != nil {
            self.avatarImageView.setImageWithURL(
                NSURL(string: issue.reportedBy!.avatar!),
                placeholderImage: Theme.userMenuImage()
            )
        } else {
            self.avatarImageView.image = Theme.userMenuImage()
        }
    }
    
    class func estimatedHeight() -> CGFloat {
        return 140.0
    }
    
    class func cellForIssue(issue: Issue, tableView: UITableView, indexPath: NSIndexPath) -> IssueCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("IssueCell",
            forIndexPath: indexPath) as! IssueCell
        cell.setupCell(issue)
        return cell
    }
    
    class func heightForIssue(issue: Issue, tableView: UITableView) -> CGFloat {
        let cell = tableView.dequeueReusableCellWithIdentifier("IssueCell") as! IssueCell
        cell.setupCell(issue)
        cell.layoutSubviews()
        return cell.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
    }
}
