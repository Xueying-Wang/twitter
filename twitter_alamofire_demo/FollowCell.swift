//
//  FollowCell.swift
//  twitter_alamofire_demo
//
//  Created by Xueying Wang on 7/6/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage

class FollowCell: UITableViewCell {

    @IBOutlet weak var avatarView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var screenNameLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var user: User!{
        didSet{
            nameLabel.text = user.name
            screenNameLabel.text = "@" + (user.screenName ?? "user")
            descriptionLabel.text = user.description
            avatarView.af_setImage(withURL: user.avatarURL!)
            avatarView.clipsToBounds = true
            avatarView.layer.cornerRadius = 20
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
