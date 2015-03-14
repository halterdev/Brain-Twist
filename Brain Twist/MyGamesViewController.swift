//
//  MyGamesViewController.swift
//  Brain Twist
//
//  Created by Jim Halter on 3/11/15.
//  Copyright (c) 2015 HalterDev. All rights reserved.
//

import Foundation
import UIKit

class MyGamesViewController: UIViewController
{
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnNewGamePressed(sender: AnyObject)
    {
        var vc = self.storyboard?.instantiateViewControllerWithIdentifier("vcGame") as GameViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
}