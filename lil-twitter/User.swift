//
//  User.swift
//  lil-twitter
//
//  Created by Marcus J. Ellison on 5/19/15.
//  Copyright (c) 2015 Marcus J. Ellison. All rights reserved.
//

import UIKit

var _currentUser: User?
let currentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
    var name: String?
    var screenname: String?
    var profileImageURL: String?
    var tagline: String?
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        profileImageURL = dictionary["profile_image_url"] as? String
        tagline = dictionary["description"] as? String
    }
    
    func logout() {
        //clear current user
        User.currentUser = nil
        
        //clear access token in twitter client
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        //
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    
    }
    
    class var currentUser: User? {
        get {
            // either there is no current user (logged out) or
            // just haven't booted from disk yet
            if _currentUser == nil {
                var data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
                if data != nil {
        var dictionary = NSJSONSerialization.JSONObjectWithData( data!, options: nil, error: nil) as? NSDictionary
                    _currentUser = User(dictionary: dictionary!)
                }
            }
        
            return _currentUser
        }
        
        set(user) {
            _currentUser = user
            
            if _currentUser != nil {
                //change to serialized json string
                var data = NSJSONSerialization.dataWithJSONObject(user!.dictionary!, options: nil, error: nil)
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
                
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
}
