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
    @IBOutlet weak var replyImageView: UIImageView!
    @IBOutlet weak var favoriteImageView: UIImageView!
    @IBOutlet weak var bottomRetweetLabel: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        thumbImageView.layer.cornerRadius = 4
        thumbImageView.clipsToBounds = true
        
        retweetImageView.image = UIImage(named: "retweet")
        replyImageView.image = UIImage(named: "reply")
        favoriteImageView.image = UIImage(named: "favorite")
        bottomRetweetLabel.image = UIImage(named: "retweet")
        
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
            
        }
    }

}
