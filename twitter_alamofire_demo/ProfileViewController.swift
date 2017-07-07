//
//  ProfileViewController.swift
//  twitter_alamofire_demo
//
//  Created by Xueying Wang on 7/5/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit
import AlamofireImage

class ProfileViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, ComposeViewControllerDelegate {
    
    @IBOutlet weak var avatarView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    
    var tweets: [Tweet] = []
    var timeline: [Tweet] = []
    var favorites: [Tweet] = []
    
    let refreshControl = UIRefreshControl()
    
    var user: User = User.current!{
        didSet{
            nameLabel.text = user.name ?? "user"
            screenNameLabel.text = "@" + (user.screenName ?? "@user")
            followingCountLabel.text = "\(user.following_count ?? 0)"
            followersCountLabel.text = "\(user.followers_count ?? 0)"
            descriptionLabel.text = user.description
            backgroundImageView.af_setImage(withURL: user.backgroundURL!)
            avatarView.af_setImage(withURL: user.avatarURL!)
            avatarView.clipsToBounds = true
            avatarView.layer.cornerRadius = 40
            avatarView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).cgColor
            avatarView.layer.borderWidth = 5
        }
    }
    
    
    func fetchData(){
        nameLabel.text = user.name ?? "user"
        screenNameLabel.text = "@" + (user.screenName ?? "@user")
        followingCountLabel.text = "\(user.following_count ?? 0)"
        followersCountLabel.text = "\(user.followers_count ?? 0)"
        descriptionLabel.text = user.description
        backgroundImageView.af_setImage(withURL: user.backgroundURL!)
        avatarView.af_setImage(withURL: user.avatarURL!)
        avatarView.clipsToBounds = true
        avatarView.layer.cornerRadius = 40
        avatarView.layer.borderColor = UIColor(white: 1, alpha: 1).cgColor
        avatarView.layer.borderWidth = 5
    }
    
    func fetchTweets(){
        APIManager.shared.getUserTimeLine { (tweets, error) in
            if let tweets = tweets {
                self.timeline = tweets
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            } else if let error = error {
                print("Error getting user timeline: " + error.localizedDescription)
            }
        }
        APIManager.shared.getUserFavoriteList { (tweets, error) in
            if let tweets = tweets {
                self.favorites = tweets
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            } else if let error = error {
                print("Error getting user favorite tweets: " + error.localizedDescription)
            }
        }
    }
    
    @IBAction func onSegmentedChange(_ sender: UISegmentedControl) {
        let index = segmentedControl.selectedSegmentIndex
        if index == 0 {
            tweets = timeline
            self.tableView.reloadData()
        } else {
            tweets = favorites
            self.tableView.reloadData()
        }
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        fetchData()
        fetchTweets()
        
        APIManager.shared.getUserTimeLine { (tweets, error) in
            if let tweets = tweets {
                self.timeline = tweets
                self.tweets = tweets
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
            } else if let error = error {
                print("Error getting user timeline: " + error.localizedDescription)
            }
        }
        
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshControlAction(_ refreshControl: UIRefreshControl) {
        fetchData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        cell.tweet = tweets[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func insertIntoTimeline(tweet: Tweet) {
        tweets.insert(tweet, at: 0)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "composeSegue" {
            let composeViewController = segue.destination as! ComposeViewController
            composeViewController.delegate = self
        }
        if segue.identifier == "detailSegue" {
            let cell = sender as! UITableViewCell
            if let indexPath = tableView.indexPath(for: cell){
                let tweet = tweets[indexPath.row]
                let detailViewController = segue.destination as! DetailViewController
                detailViewController.tweet = tweet
            }
        }
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
