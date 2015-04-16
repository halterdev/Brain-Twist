//
//  HomeViewController.swift
//  Brain Twist
//
//  Created by Jim Halter on 3/31/15.
//  Copyright (c) 2015 HalterDev. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController: UIViewController
{
    @IBOutlet weak var topView: UIView!
    
    override func viewDidLoad()
    {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bkground.png")!)
        
        topView.backgroundColor = GameLogic.UIColorFromRGB("FEB09E", alpha: 1.0)
        
    }
    
    @IBAction func btnLogoutPressed(sender: AnyObject)
    {
        PFUser.logOut()
        
        var vc = self.storyboard?.instantiateViewControllerWithIdentifier("MainMenuViewController") as! MainMenuViewController
        self.presentViewController(vc, animated: false, completion: nil)
    }
}