//
//  ViewController.swift
//  lil-twitter
//
//  Created by Marcus J. Ellison on 5/18/15.
//  Copyright (c) 2015 Marcus J. Ellison. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLogin(sender: AnyObject) {
        // but the code below is cloogey. Ideally what we want to manage mentally in the view is:
//        TwitterClient.sharedInstance.loginWithBlock() {
            //go to next screen
//        }
        
        
        //clear cache of tokens stored by BBDOObject so that this instance does not assume it's signed in
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        // instance request
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential!) -> Void in
            
            var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)" )
            UIApplication.sharedApplication().openURL(authURL!)
            
            println("got the request token")
            }) { (error: NSError!) -> Void in
            println("Failed to get request token")
        }
    }

}

