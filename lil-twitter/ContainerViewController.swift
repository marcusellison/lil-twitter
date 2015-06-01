//
//  ContainerViewController.swift
//  lil-twitter
//
//  Created by Marcus J. Ellison on 5/31/15.
//  Copyright (c) 2015 Marcus J. Ellison. All rights reserved.
//

import UIKit

enum SlideOutState {
    case BothCollapsed
    case LeftPanelExpanded
    case RightPanelExpanded
}


class ContainerViewController: UIViewController, MenuControllerDelegate, TweetCellDelegate {
    
    private var profileViewController: ProfileViewController!
    private var sidePanelViewController: SidePanelViewController!
    private var mentionsViewController: MentionsViewController!
    
    var centerNavigationController: UINavigationController!
    
    var centerViewController: TweetsViewController!
    
    
    var currentState: SlideOutState = .BothCollapsed {
        didSet {
            let shouldShowShadow = currentState != .BothCollapsed
            showShadowForCenterViewController(shouldShowShadow)
        }
    }
    var leftViewController: SidePanelViewController?
    let centerPanelExpandedOffset: CGFloat = 100

    override func viewDidLoad() {
        super.viewDidLoad()
        
        centerViewController = UIStoryboard.centerViewController()
        centerViewController.tweetDelegate = self;
        centerNavigationController = UINavigationController(rootViewController: centerViewController)
        centerNavigationController.navigationBar.barTintColor = UIColor(red: 0.33, green: 0.674, blue: 0.933, alpha: 0)
        
        profileViewController = UIStoryboard.profileViewController()
        profileViewController.delegate = self
        mentionsViewController = UIStoryboard.mentionsViewController()
        mentionsViewController.delegate = self
        
        displayVC(centerNavigationController)
        
        
        // add gesture recognizer
//        var tapGesture = UITapGestureRecognizer(target: self, action: "handleTapGesture:")
//        tapGesture.delegate = self
//        view.addGestureRecognizer(tapGesture)
//        
//        func handleTapGesture(sender: UITapGestureRecognizer) {
//            println("handleTap")
//            
//            if (sender.state == .Ended) {
//                animateLeftPanel(shouldExpand: false)
//            }
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

/* Main View Controller Delegate */

extension ContainerViewController: TweetsViewControllerDelegate {
    
    func toggleLeftPanel() {
        println("adding left panel")
        let notAlreadyExpanded = (currentState != .LeftPanelExpanded)
        
        println(notAlreadyExpanded)
        
        if notAlreadyExpanded {
            addLeftPanelViewController()
        }
        
        animateLeftPanel(shouldExpand: notAlreadyExpanded)
    }
    
    func addLeftPanelViewController() {
        if (leftViewController == nil) {
            leftViewController = UIStoryboard.leftViewController()
            
            addChildSidePanelController(leftViewController!)
            leftViewController?.delegate = self
        }
    }
    
    func addChildSidePanelController(sidePanelController: SidePanelViewController) {
        view.insertSubview(sidePanelController.view, atIndex: 0)
        
        addChildViewController(sidePanelController)
        sidePanelController.didMoveToParentViewController(self)
        println("insert child view controller")
    }
    
    func animateLeftPanel(#shouldExpand: Bool) {
        if (shouldExpand) {
            
            println("should open")
            currentState = .LeftPanelExpanded
            
            animateCenterPanelXPosition(targetPosition: CGRectGetWidth(centerNavigationController.view.frame) - centerPanelExpandedOffset)
        } else {
            animateCenterPanelXPosition(targetPosition: 0) { finished in
                self.currentState = .BothCollapsed
                println("\(self.leftViewController)")
//                self.leftViewController!.view.removeFromSuperview()
                self.leftViewController = nil;
            }
        }
    }
    
    func animateCenterPanelXPosition(#targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .CurveEaseInOut, animations: {
            self.centerNavigationController.view.frame.origin.x = targetPosition
            }, completion: completion)
    }
    
    func showShadowForCenterViewController(shouldShowShadow: Bool) {
        if (shouldShowShadow) {
            centerNavigationController.view.layer.shadowOpacity = 0.8
        } else {
            centerNavigationController.view.layer.shadowOpacity = 0.0
        }
    }
    
    ///////////The Code of the Code!!!/////////
    
    // Add gestures
//    var tapGesture = UITapGestureRecognizer(target: self, action: "handleTapGesture:")
//    tapGesture.delegate = self
//    containerView.addGestureRecognizer(tapGesture)
    

    func showMentions() {
        displayVC(mentionsViewController)
        animateLeftPanel(shouldExpand: false)
    }
    
    func showProfile() {
        profileViewController.user = User.currentUser
        displayVC(profileViewController)
        animateLeftPanel(shouldExpand: false)
    }
    
    func showTimeline() {
        displayVC(centerNavigationController) //added instantiation - is this correct?
        animateLeftPanel(shouldExpand: false)
    }
    
    func displayVC(vc: UIViewController) {
        
        addChildViewController(vc)
        vc.view.frame = view.bounds
        view.addSubview(vc.view)
        vc.didMoveToParentViewController(self)
    }
    
    func userTapped(user: User) {
        println("code working here")
    }
    
    ///////////The Code of the Code!!!/////////
    
}

private extension UIStoryboard {
    
    class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()) }
    
    class func leftViewController() -> SidePanelViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("LeftViewController") as? SidePanelViewController
    }
    
    class func centerViewController() -> TweetsViewController? {
        println("instantiated")
        return mainStoryboard().instantiateViewControllerWithIdentifier("TweetsViewController") as? TweetsViewController
    }
    
    // SETUP Profile
    class func profileViewController() -> ProfileViewController? {
        println("instantiating profile view")
//        profileViewController = storyboard?.instantiateViewControllerWithIdentifier("ProfileViewController") as ProfileViewController
//        profileViewController.isModal = false
//        profileViewController.delegate = self
        
        return mainStoryboard().instantiateViewControllerWithIdentifier("ProfileViewController") as? ProfileViewController
    }
    
    class func mentionsViewController() -> MentionsViewController? {
        println("instantiating profile view")
        //        profileViewController = storyboard?.instantiateViewControllerWithIdentifier("ProfileViewController") as ProfileViewController
        //        profileViewController.isModal = false
        //        profileViewController.delegate = self
        
        return mainStoryboard().instantiateViewControllerWithIdentifier("MentionsViewController") as? MentionsViewController
    }
    
    
    
}

