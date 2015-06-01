//
//  ProfileViewController.swift
//  lil-twitter
//
//  Created by Marcus J. Ellison on 5/31/15.
//  Copyright (c) 2015 Marcus J. Ellison. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    var isModal = true
    var user: User!
    var delegate: MenuControllerDelegate?
    
    @IBOutlet weak private var bannerImage: UIImageView!
    @IBOutlet weak var numFollowersLabel: UILabel!
    @IBOutlet weak var numFollowingLabel: UILabel!
    @IBOutlet weak var numTweetsLabel: UILabel!
    
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var navBar: UINavigationBar!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        var url = NSURL(string: user!.largeProfileImage())
        bannerImage.setImageWithURL(url)
        bannerImage.alpha = 0.6
        
        numTweetsLabel.text = "\(user.tweetCount)"
        numFollowersLabel.text = "\(user.followersCount)"
        numFollowingLabel.text = "\(user.followingCount)"
        
        nameLabel.text = user.name!
        
        var item = navBar.items[0] as! UINavigationItem
        item.title = "Profile"
        
//        if !isModal {
            item.leftBarButtonItem = UIBarButtonItem(title: "Main", style: UIBarButtonItemStyle.Done, target: self, action: "doneTapped:")
//        }

        // Do any additional setup after loading the view.
    }
    
    func doneTapped(sender: UIBarButtonItem) {
        
        delegate?.showTimeline()
        
//        performSegueWithIdentifier("newTweet", sender: sender)
//        
//        dismissViewControllerAnimated(true, completion: nil)
        
//        if isModal {
//            dismissViewControllerAnimated(true, completion: nil)
//        } else {
//            delegate?.toggleLeftPanel()
//        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
