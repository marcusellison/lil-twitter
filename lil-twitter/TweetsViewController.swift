//
//  TweetsViewController.swift
//  lil-twitter
//
//  Created by Marcus J. Ellison on 5/19/15.
//  Copyright (c) 2015 Marcus J. Ellison. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]?
    
    var refreshControl: UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate  = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)

        loadTweets()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
//     MARK: - Navigation

//     In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "tweetDetail" {
            let cell = sender as! UITableViewCell
            
            let indexPath = tableView.indexPathForCell(cell)!
            
            let tweetDetailViewController = segue.destinationViewController as! TweetDetailViewController
            
            let tweet = tweets![indexPath.row]
            
            tweetDetailViewController.tweet = tweet
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        } else {
            println("new tweet segue")
        }
        
        
    }
    
    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
        
    }

    @IBAction func onNewTweet(sender: AnyObject) {
        println("trigger new tweet")
        performSegueWithIdentifier("newTweet", sender: sender)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tweets != nil {
            return tweets!.count
        } else {
            return 0
        }
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    func onRefresh() {
        loadTweets()
        
        delay(2, closure: {
            self.refreshControl.endRefreshing()
        })
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        
        cell.tweet = tweets![indexPath.row]
        
        return cell
    }
    
    func loadTweets() {
        // return first 20 tweets by default via twitter api
        TwitterClient.sharedInstance.homeTimelineWithParams(nil, completion: { (tweets, error) -> () in
            self.tweets = tweets!
            self.tableView.reloadData()
        })
    }
    
//    func composeViewController(composeViewController: ComposeViewController, didPostNewTweet tweet: Tweet) {
//        self.tweets = [tweet] + self.tweets!
//        self.tableView.reloadData()
//    }

}
