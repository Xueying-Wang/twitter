//
//  ComposeViewController.swift
//  twitter_alamofire_demo
//
//  Created by Xueying Wang on 7/5/17.
//  Copyright © 2017 Charles Hieger. All rights reserved.
//

import UIKit

protocol ComposeViewControllerDelegate{
    func insertIntoTimeline(tweet: Tweet)
}

class ComposeViewController: UIViewController {
    
    var delegate: ComposeViewControllerDelegate?
    
    @IBOutlet weak var tweetTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postTweet(_ sender: UIButton) {
        APIManager.shared.composeTweet(with: tweetTextField.text ?? "") { (tweet, error) in
            if let error = error {
                print("Error composing Tweet: \(error.localizedDescription)")
            } else if let tweet = tweet {
                self.delegate?.insertIntoTimeline(tweet: tweet)
                print("Compose Tweet Success!")
                self.dismiss(animated: true, completion: nil)
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
