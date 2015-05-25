//
//  Tweet.swift
//  lil-twitter
//
//  Created by Marcus J. Ellison on 5/19/15.
//  Copyright (c) 2015 Marcus J. Ellison. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var imageURL: NSURL?
    var retweetedBy: String?
    var retweeted: Bool?
    var favorited: Bool?
    
    
    init(dictionary: NSDictionary) {
        user = User(dictionary: (dictionary["user"] as! NSDictionary))
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        
        // N.B. NSDateFormatter is really expensive
        // would be better to use a lazy load or a 'static NSDateFormatter'
        var formatter = NSDateFormatter()
        
        // date format must match exactly
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        
//        formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        
        createdAt = formatter.dateFromString(createdAtString!)
        
        var imageURLString = user?.profileImageURL
        if imageURLString != nil {
            imageURL = NSURL(string: imageURLString!)!
        } else {
            imageURL = nil
        }
        
        retweeted = dictionary["retweeted"] as? Bool
        favorited = dictionary["favorited"] as? Bool
    }
    
    // convenience method that parses an array of tweets
    class func tweetsWithArray( array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for (dictionary) in array{
            tweets.append(Tweet(dictionary: dictionary))
            
        }
        
        return tweets
    }
}
