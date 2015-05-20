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
            //println("home timeline \(response)")
            var tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            completion(tweets: tweets, error: nil)
            
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Error getting home timeline")
                completion( tweets: nil, error: error)
        })
        
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
