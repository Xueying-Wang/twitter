//
//  DetailViewController.swift
//  twitter_alamofire_demo
//
//  Created by Xueying Wang on 7/5/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage

class DetailViewController: UIViewController {
    
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    
    
    var tweet: Tweet!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tweetTextLabel.text = tweet.text
        nameLabel.text = tweet.user.name
        screenNameLabel.text = "@" + (tweet.user.screenName ?? "")
        timeLabel.text = tweet.createdAtString
        
        retweetCountLabel.text = "\(tweet.retweetCount ?? 0)"
        favoriteCountLabel.text = "\(tweet.favoriteCount ?? 0)"
        avatarView.af_setImage(withURL: tweet.user.avatarURL!)
        avatarView.clipsToBounds = true
        avatarView.layer.cornerRadius = 25
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        timeLabel.text = tweet.createdAtString
        
        retweetCountLabel.text = "\(tweet.retweetCount ?? 0)"
        favoriteCountLabel.text = "\(tweet.favoriteCount ?? 0)"
        avatarView.af_setImage(withURL: tweet.user.avatarURL!)
        avatarView.clipsToBounds = true
        avatarView.layer.cornerRadius = 25
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
