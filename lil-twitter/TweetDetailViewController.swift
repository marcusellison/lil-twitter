//
//  TweetDetailViewController.swift
//  lil-twitter
//
//  Created by Marcus J. Ellison on 5/22/15.
//  Copyright (c) 2015 Marcus J. Ellison. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {
    
    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var retweetImageView: UIImageView!
    @IBOutlet weak var retweetUsernameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var tweetDescriptionLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var replyImageView: UIImageView!
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var bottomRetweetLabel: UIImageView!
    
    var tweet: Tweet!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        thumbImageView.layer.cornerRadius = 4
        thumbImageView.clipsToBounds = true
        
        thumbImageView.setImageWithURL(tweet.imageURL)
        retweetImageView.image = UIImage(named: "retweet")
        replyImageView.image = UIImage(named: "reply")
        favoriteImageView.image = UIImage(named: "favorite")
        bottomRetweetLabel.image = UIImage(named: "retweet")
        
        userNameLabel.text = tweet.user?.name
        tweetDescriptionLabel.text = tweet.text
        createdAtLabel.text = "\(tweet.createdAt!)"
        screennameLabel.text = "@\(tweet.user!.screenname!)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
