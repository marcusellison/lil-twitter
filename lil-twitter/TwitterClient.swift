//
//  TwitterClient.swift
//  lil-twitter
//
//  Created by Marcus J. Ellison on 5/18/15.
//  Copyright (c) 2015 Marcus J. Ellison. All rights reserved.
//

import UIKit

let twitterConsumerKey = "te5YAGUQx0Y7q5j8gYgwc8f4v"
let twitterConsumerSecret = "zMBd8YAqBkJXu4A1wFYrYDZ32dQn5BCAGWERPvfFiNMmCq9tnu"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    // will hold clojure until we're ready to use it
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> () ) {
        // doesn't need the shared instance because this is the shared instance
        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            completion(tweets: tweets, error: nil)
            
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Error getting home timeline")
                completion( tweets: nil, error: error)
        })
    }
    
    func postTweet( tweetText: String!, completion: (tweet: Tweet?, error: NSError?) -> ()  ) {
        var params: NSDictionary?
        
        params = ["status": tweetText]
        
        println("Tweet would be posted.")
        
//        POST("1.1/statuses/update.json", parameters: params!, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
//            var tweet = Tweet(dictionary: response as! NSDictionary)
//            println("Success! Tweet Post Text: \(tweet.text!)")
//            completion(tweet: tweet, error: nil)
//            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
//                println("post")
//                println(error)
//                completion(tweet: nil, error: error)
//        }
    }
    
    func replyTweet(tweetText: String!, tweetID: String!, completion: (tweet: Tweet?, error: NSError?) -> () ) {
        
        var params: NSDictionary?
        
        params = ["status": tweetText, "in_reply_to_status_id" : tweetID]
        
        POST("1.1/statuses/update.json", parameters: params!, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            var tweet = Tweet(dictionary: response as! NSDictionary)
            println("Tweet replied to! \(tweet.tweetID!)")
            completion(tweet: tweet, error: nil)
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Failed to reply!")
                println(error)
                completion(tweet: nil, error: error)
        }
        
    }
    
    func favorite(tweetID: String!, completion: (tweet: Tweet?, error: NSError?) -> () ) {
        
        POST("1.1/favorites/create.json", parameters: ["id":tweetID], success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            println("Tweet Favorited! :-) Id: \(tweetID)")
            var tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet: tweet, error: nil)
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Favoriting tweet failed :-( \(tweetID)")
                println(error)
                completion(tweet: nil, error: error)
        }
        
    }
    
    func retweet(tweet: Tweet, completion: (tweet: Tweet?, error: NSError?) -> () ) {
        
        var tweetID = tweet.tweetIDString!
        var url = "1.1/statuses/retweet/" + tweetID + ".json"
        
        POST(url, parameters: ["trim_user" : false], success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            
            println("Tweet Retweeted! \(tweetID)")
            var tweet = Tweet(dictionary: response as! NSDictionary)
            completion(tweet: tweet, error: nil)
            
        }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
            
            println("Retweet unsuccessful with tweet Id: \(tweetID)")
            println(error)
            completion(tweet: nil, error: error)
            
        }
    }
    

    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> () ) {
        loginCompletion = completion
        
        //clear cache of tokens stored by BBDOObject so that this instance does not assume it's signed in
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        // Fetch request token and redirect to authorization page
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            
            var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)" )
            UIApplication.sharedApplication().openURL(authURL!)
            
            println("got the request token")
            }) { (error: NSError!) -> Void in
                println("Failed to get request token")
                
                // tell the original caller of the login that the error happened
                self.loginCompletion?(user: nil, error: error)
        }
    }
    

    
    func openURL(url: NSURL) {
        
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential (queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            println("got access token")
            
        TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
        
        
        // get current user
        TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            //                    println("user:\(response)")
            var user = User(dictionary: response as! NSDictionary)
            User.currentUser = user
            println("user: \(user.name)")
            
            // pass in user to loginCompletion
            self.loginCompletion?(user: user, error: nil)
            
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("error getting current user")
                // tell the original caller of the login that the error happened
                self.loginCompletion?(user: nil, error: error)
            })
        
        }) { (error: NSError!) -> Void in
            println("error getting home timeline")
            // tell the original caller of the login that the error happened
            self.loginCompletion?(user: nil, error: error)
            
        }
    }
}
