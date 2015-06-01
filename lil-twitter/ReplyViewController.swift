//
//  ReplyViewController.swift
//  lil-twitter
//
//  Created by Marcus J. Ellison on 5/24/15.
//  Copyright (c) 2015 Marcus J. Ellison. All rights reserved.
//

import UIKit

class ReplyViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var thumbLabel: UIImageView!
    @IBOutlet weak var tweetField: UITextField!



    var tweet: Tweet!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        var imageURL = NSURL(string: User.currentUser!.profileImageURL!)
        nameLabel.text = User.currentUser?.name
        screennameLabel.text = User.currentUser?.screenname
        thumbLabel.setImageWithURL(imageURL)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onReply(sender: AnyObject) {
        println("replying now")

        var tweetID = tweet.tweetIDString

        var text = "@" + tweet.user!.screenname! + " " + tweetField.text

        TwitterClient.sharedInstance.replyTweet(tweetField.text, tweetID: tweetID) { (tweet, error) -> () in
            self.navigationController?.popViewControllerAnimated(true)
        }



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
