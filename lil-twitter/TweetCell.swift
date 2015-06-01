//
//  TweetCell.swift
//  lil-twitter
//
//  Created by Marcus J. Ellison on 5/21/15.
//  Copyright (c) 2015 Marcus J. Ellison. All rights reserved.
//

import UIKit

protocol TweetCellDelegate {
    func userTapped(user : User)
}

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
    
    let tapRecognizer = UITapGestureRecognizer()
    
    var delegate: TweetCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        thumbImageView.layer.cornerRadius = 4
        thumbImageView.clipsToBounds = true
        
        retweetImageView.image = UIImage(named: "retweet")
        
        //initially hide retweet view
        retweetImageView.hidden = true
        retweetUsernameLabel.hidden = true
        
        // enable user interation on the image
        thumbImageView.userInteractionEnabled = true
        tapRecognizer.addTarget(self, action: "userTapped")
        thumbImageView.addGestureRecognizer(tapRecognizer)
        
        
//        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    func userTapped(){
        println("Image tapped")
        
        if let delegate = delegate {
            delegate.userTapped(tweet!.user!)
        }
        
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
            self.delegate = self as? TweetCellDelegate
        }
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        
        TwitterClient.sharedInstance.favorite(tweet.tweetIDString!, completion: { (tweet, error) -> () in
            if error == nil {
                println("Tweet Favorited!")
                self.favoriteButton.selected = true
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
            } else {
                println(("Error retweeting!"))
            }
        })
    }
    
    @IBAction func onReply(sender: AnyObject) {
//        performSegueWithIdentifier("replyTweet", sender: sender)
        
    }
    

}
