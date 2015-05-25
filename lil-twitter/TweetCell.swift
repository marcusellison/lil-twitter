//
//  TweetCell.swift
//  lil-twitter
//
//  Created by Marcus J. Ellison on 5/21/15.
//  Copyright (c) 2015 Marcus J. Ellison. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var retweetImageView: UIImageView!
    @IBOutlet weak var retweetUsernameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var createdAtLabel: UILabel!
    @IBOutlet weak var tweetDescriptionLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    
    @IBOutlet weak var replyButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        thumbImageView.layer.cornerRadius = 4
        thumbImageView.clipsToBounds = true
        
        retweetImageView.image = UIImage(named: "retweet")
        
        //initially hide retweet view
        retweetImageView.hidden = true
        retweetUsernameLabel.hidden = true
        
        //What this?
//        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var tweet: Tweet! {
        
        didSet {
            thumbImageView.setImageWithURL(tweet.imageURL)
            userNameLabel.text = tweet.user?.name
            tweetDescriptionLabel.text = tweet.text
            createdAtLabel.text = "\(tweet.createdAt!)"
            screennameLabel.text = "@\(tweet.user!.screenname!)"
            
            if tweet.retweeted == true {
                retweetImageView.hidden = true
                retweetUsernameLabel.hidden = true
            } else {
                retweetImageView.hidden = false
                retweetUsernameLabel.hidden = false
            }
            
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
            
        }
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        
        TwitterClient.sharedInstance.favorite(tweet.tweetIDString!, completion: { (tweet, error) -> () in
            if error == nil {
                println("Tweet Favorited!")
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
                self.retweetButton.selected = true
                //                (self.delegate?.budgieDetailsActionsCell!(self, didChangeReTweetedStatus:  !(self.tweet.isRetweeted!)))
            } else {
                println(("Error retweeting!"))
            }
        })
    }
    
    @IBAction func onReply(sender: AnyObject) {
//        performSegueWithIdentifier("replyTweet", sender: sender)
        
    }
    

}
