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

    @IBOutlet weak var retweetUsernameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var tweetDescriptionLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var replyImageView: UIImageView!

    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    @IBOutlet weak var retweetsCountLabel: UILabel!
    @IBOutlet weak var favoritesCountLabel: UILabel!
    
    var tweet: Tweet!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if tweet.favorited! {
            favoriteButton.selected = true
        } else {
            favoriteButton.selected = false
        }
        
        if tweet.retweeted! {
            retweetButton.selected = true
        } else {
            retweetButton.selected = false
        }

        thumbImageView.layer.cornerRadius = 4
        thumbImageView.clipsToBounds = true
        
        thumbImageView.setImageWithURL(tweet.imageURL)
        replyImageView.image = UIImage(named: "reply")
        
        userNameLabel.text = tweet.user?.name
        tweetDescriptionLabel.text = tweet.text
        createdAtLabel.text = "\(tweet.createdAt!)"
        screennameLabel.text = "@\(tweet.user!.screenname!)"
        favoritesCountLabel.text = "\(tweet.favoritesCount!)"
        retweetsCountLabel.text = "\(tweet.retweetsCount!)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onFavorite(sender: AnyObject) {
        
        TwitterClient.sharedInstance.favorite(tweet.tweetIDString!, completion: { (tweet, error) -> () in
            if error == nil {
                println("Tweet favorited")
                self.favoritesCountLabel.text = "\(self.tweet.favoritesCount! + 1)"
                self.favoriteButton.selected = true
//                (self.delegate?.budgieDetailsActionsCell!(self, didChangeFavoriteStatus:  !(self.tweet.isFavorited!)))
            } else {
                println(("favoriting error"))
            }
        })
    }
    
    @IBAction func onRetweet(sender: AnyObject) {
        TwitterClient.sharedInstance.retweet(tweet, completion: { (tweet, error) -> () in
            if error == nil {
                println("Successful retweet!")
                self.retweetsCountLabel.text = "\(self.tweet.retweetsCount! + 1)"
                self.retweetButton.selected = true
                //                (self.delegate?.budgieDetailsActionsCell!(self, didChangeReTweetedStatus:  !(self.tweet.isRetweeted!)))
            } else {
                println(("Error retweeting!"))
            }
        })

    }
    
    @IBAction func onReply(sender: AnyObject) {
        performSegueWithIdentifier("replyTweet", sender: sender)
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "replyTweet" {
            
            let replyViewController =  segue.destinationViewController as! ReplyViewController
            
            replyViewController.tweet = tweet
            
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }


}
