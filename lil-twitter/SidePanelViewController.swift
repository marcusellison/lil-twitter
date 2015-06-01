//
//  SidePanelViewController.swift
//  lil-twitter
//
//  Created by Marcus J. Ellison on 5/31/15.
//  Copyright (c) 2015 Marcus J. Ellison. All rights reserved.
//

import UIKit

class SidePanelViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var menuItems = ["Profile", "Timeline", "Mentions"]
    var delegate: MenuControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: CGRectZero)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
        tableView.selectRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0), animated: true, scrollPosition: UITableViewScrollPosition.Top)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("MenuCell") as! MenuCell
        
        var text = menuItems[indexPath.row]
        
        
        cell.textLabel?.text = text
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var row = indexPath.row
        
        println("something happening")
        println(row)
        
        switch row {
        case 0: delegate?.showProfile()
        case 1: delegate?.showTimeline()
        case 2: delegate?.showMentions()
        default: delegate?.showTimeline()
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection
        
        section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCellWithIdentifier("HeaderCell") as! HeaderCell
        headerCell.backgroundColor = UIColor.cyanColor()
        
//        headerCell.titleLabel.text = "text"
        
        return headerCell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100.0
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

protocol MenuControllerDelegate {
    func toggleLeftPanel()
    func showProfile()
    func showTimeline()
    func showMentions()
}
