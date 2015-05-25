//
//  ComposeViewController.swift
//  lil-twitter
//
//  Created by Marcus J. Ellison on 5/22/15.
//  Copyright (c) 2015 Marcus J. Ellison. All rights reserved.
//

import UIKit

//@objc protocol ComposeViewControllerDelegate {
//    optional func composeViewController(composeViewController: ComposeViewController, didPostNewTweet tweet: Tweet)
//}

class ComposeViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var thumbLabel: UIImageView!
    @IBOutlet weak var tweetField: UITextField!
    
//    weak var delegate: ComposeViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var imageURL = NSURL(string: User.currentUser!.profileImageURL!)

        nameLabel.text = User.currentUser?.name
        screennameLabel.text = User.currentUser?.screenname
        thumbLabel.setImageWithURL(imageURL)
        
        self.navigationItem.title = "140"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func postTweet(sender: AnyObject) {
        
        println("posting tweet")
        
        var tweetText = tweetField.text
        
        TwitterClient.sharedInstance.postTweet(tweetField.text) { (tweet, error) -> () in
            //used if segue transition is modal: self.dismissViewControllerAnimated(true, completion: nil)
//            self.delegate?.composeViewController!(self, didPostNewTweet: tweet!)
            //used because transition is show
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
    
    // change text count
    @IBAction func onCharacterChange(sender: AnyObject) {
        self.navigationItem.title = "\(140 - count(tweetField.text))"
    }
    
}
