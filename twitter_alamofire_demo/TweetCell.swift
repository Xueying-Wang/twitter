//
//  TweetCell.swift
//  twitter_alamofire_demo
//
//  Created by Charles Hieger on 6/18/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage

protocol TweetCellDelegate: class {
    func didTapProfile (_ sender: UITapGestureRecognizer)
}

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var authorAvatarView: UIImageView!
    
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    weak var delegate: TweetCellDelegate!
    
    
    var tweet: Tweet! {
        didSet {
            tweetTextLabel.text = tweet.text
            nameLabel.text = tweet.user.name
            screenNameLabel.text = "@" + (tweet.user.screenName ?? "")
            dateLabel.text = tweet.createdAtString
            
            retweetCountLabel.text = "\(tweet.retweetCount ?? 0)"
            favoriteCountLabel.text = "\(tweet.favoriteCount ?? 0)"
            authorAvatarView.af_setImage(withURL: tweet.user.avatarURL!)
            authorAvatarView.clipsToBounds = true
            authorAvatarView.layer.cornerRadius = 30
        }
    }
    
    
    
    @IBAction func retweet(_ sender: UIButton) {
        tweet.retweeted = true
        tweet.retweetCount += 1
        sender.isSelected = true
        refreshData()
        APIManager.shared.retweet(tweet) { (tweet: Tweet?, error: Error?) in
            if let error = error {
                print("Error retweeting: \(error.localizedDescription)")
            } else if let tweet = tweet {
                print("Successfully retweeted the following Tweet: \n\(tweet.text)")
            }
        }
    }
    
    @IBAction func favorite(_ sender: UIButton) {
        tweet.favorited = true
        tweet.favoriteCount = (tweet.favoriteCount ?? 0) + 1
        sender.isSelected = true
        refreshData()
        APIManager.shared.favorite(tweet) { (tweet: Tweet?, error: Error?) in
            if let error = error {
                print("Error favoriting tweet: \(error.localizedDescription)")
            } else if let tweet = tweet {
                print("Successfully favorited the following Tweet: \n\(tweet.text)")
            }
        }
    }
    
    func refreshData(){
        tweetTextLabel.text = tweet.text
        nameLabel.text = tweet.user.name
        screenNameLabel.text = "@" + (tweet.user.screenName ?? "")
        dateLabel.text = tweet.createdAtString
        
        retweetCountLabel.text = "\(tweet.retweetCount ?? 0)"
        favoriteCountLabel.text = "\(tweet.favoriteCount ?? 0)"
        authorAvatarView.af_setImage(withURL: tweet.user.avatarURL!)
        authorAvatarView.clipsToBounds = true
        authorAvatarView.layer.cornerRadius = 25
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
