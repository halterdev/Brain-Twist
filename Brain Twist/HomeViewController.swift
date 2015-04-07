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
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblRecord: UILabel!
    
    override func viewDidLoad()
    {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bkground.png")!)
        
        setRecordLabel()
    }
    
    private func setRecordLabel()
    {
        var stats = UserLogic.GetUsersStatRow(user: PFUser.currentUser())
        
        var wins = stats.valueForKey("Wins") as Int
        var losses = stats.valueForKey("Losses") as Int
        var draws = stats.valueForKey("Ties") as Int
        
        //lblRecord.text = "Wins \(wins) Losses \(losses) Draws \(draws)"
    }
}