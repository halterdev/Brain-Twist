//
//  MyTabBarController.swift
//  Brain Twist
//
//  Created by Jim Halter on 3/31/15.
//  Copyright (c) 2015 HalterDev. All rights reserved.
//

import Foundation
import UIKit

class MyTabBarController: UITabBarController
{
    override func viewDidAppear(animated: Bool)
    {
        var tabArray = self.tabBar.items!
        
        for tab in tabArray
        {
            var tabItem = tab as! UITabBarItem
            
            if(tabItem.title == "Games")
            {
                var turns = NumberOfTurnsUp()
                if(turns > 0)
                {
                    tabItem.badgeValue = "\(turns)"
                }
            }
        }
    }
    
    private func NumberOfTurnsUp() -> Int
    {
        var result = 0
        
        var query = PFQuery(className: "Round")
        query.includeKey("Game")
        query.whereKey("TurnPlayer", equalTo: PFUser.currentUser())
        query.whereKey("IsFinished", equalTo: false)
        query.whereKeyExists("PlayerTwo")
        
        var turns = query.findObjects()
        
        for turn in turns
        {
            result++
        }
        
        return result
    }
}