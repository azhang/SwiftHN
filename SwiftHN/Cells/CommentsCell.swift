//
//  CommentsCell.swift
//  SwiftHN
//
//  Created by Thomas Ricouard on 30/06/14.
//  Copyright (c) 2014 Thomas Ricouard. All rights reserved.
//

import UIKit
import SwiftHNShared
import HackerSwifter

let CommentsCellId = "commentCellId"
let CommentCellMarginConstant: CGFloat = 16.0
let CommentCellTopMargin: CGFloat = 5.0
let CommentCellFontSize: CGFloat = 13.0
let CommentCellUsernameHeight: CGFloat = 25.0
let CommentCellBottomMargin: CGFloat = 16.0

class CommentsCell: UITableViewCell {

    var comment: Comment! {
        didSet {
            var username = comment.username
            var date = " - " + comment.prettyTime!
            
            var usernameAttributed = NSAttributedString(string: username,
                attributes: [NSFontAttributeName : UIFont.boldSystemFontOfSize(CommentCellFontSize),
                    NSForegroundColorAttributeName: UIColorEXT.HNColor()])
            var dateAttribute = NSAttributedString(string: date,
                attributes: [NSFontAttributeName: UIFont.systemFontOfSize(CommentCellFontSize),
                    NSForegroundColorAttributeName: UIColorEXT.DateLightGrayColor()])
            var fullAttributed = NSMutableAttributedString(attributedString: usernameAttributed)
            fullAttributed.appendAttributedString(dateAttribute)
            
            self.commentLabel.font = UIFont.systemFontOfSize(CommentCellFontSize)
            
            self.usernameLabel.attributedText = fullAttributed
            self.commentLabel.text = comment.text
        }
    }
    
    var indentation: CGFloat {
        didSet {
            self.commentLeftMarginConstraint.constant = indentation
            self.usernameLeftMarginConstrain.constant = indentation
            self.commentHeightConstrain.constant =
                self.contentView.frame.size.height - CommentCellUsernameHeight - CommentCellTopMargin - CommentCellMarginConstant + 5.0
            self.contentView.setNeedsUpdateConstraints()
        }
    }
    
    @IBOutlet var usernameLabel: UILabel = nil
    @IBOutlet var commentLabel: UILabel = nil
    @IBOutlet var commentLeftMarginConstraint: NSLayoutConstraint = nil
    @IBOutlet var commentHeightConstrain: NSLayoutConstraint = nil
    @IBOutlet var usernameLeftMarginConstrain: NSLayoutConstraint = nil
    
    init(style: UITableViewCellStyle, reuseIdentifier: String) {
        self.indentation = CommentCellMarginConstant
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.commentLabel.font = UIFont.systemFontOfSize(CommentCellFontSize)
        self.commentLabel.textColor = UIColorEXT.CommentLightGrayColor()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.commentLabel.preferredMaxLayoutWidth = self.contentView.bounds.width - (self.commentLeftMarginConstraint.constant * 2) - (CommentCellMarginConstant * CGFloat(self.comment.depth!))
        self.indentation = CommentCellMarginConstant + (CommentCellMarginConstant * CGFloat(self.comment.depth!))
    }
    
    class func heightForText(text: String, bounds: CGRect, level: Int) -> CGFloat {
        var size = text.boundingRectWithSize(CGSizeMake(CGRectGetWidth(bounds) - (CommentCellMarginConstant * 2) -
            (CommentCellMarginConstant * CGFloat(level)), CGFLOAT_MAX),
            options: NSStringDrawingOptions.UsesLineFragmentOrigin,
            attributes: [NSFontAttributeName: UIFont.systemFontOfSize(CommentCellFontSize)],
            context: nil)
        return CommentCellMarginConstant + CommentCellUsernameHeight + CommentCellTopMargin + size.height + CommentCellBottomMargin
    }
}
