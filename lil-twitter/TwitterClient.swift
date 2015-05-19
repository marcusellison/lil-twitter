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
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
            
        }
        return Static.instance
    }
   
}
