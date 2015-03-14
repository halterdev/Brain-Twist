//
//  Round.swift
//  Brain Twist
//
//  Created by Jim Halter on 3/1/15.
//  Copyright (c) 2015 HalterDev. All rights reserved.
//

import Foundation
import UIKit

class Round
{
    var pfRoundObj: PFObject?
    
    var game: Game?
    
    var targetColor: UIColor?
    var targetColorID: Int?
    
    var targetShape: String?
    
    var targetText: String?
    
    init()
    {
        setTargetColor()
    }
    
    /**
        Create a PFObject representing the Round
    */
    func createRoundPFObject(#pfGameObj: PFObject)
    {
        pfRoundObj = PFObject(className: "Round")
        
        pfRoundObj?.setValue(false, forKey: "HasPlayerOnePlayed")
        pfRoundObj?.setValue(false, forKey: "HasPlayerTwoPlayed")
        pfRoundObj?.setObject(pfGameObj, forKey: "Game")
        pfRoundObj?.setValue(targetColorID, forKey: "TargetColorID")
        pfRoundObj?.setValue(5, forKey: "NumberOfCorrectObjectsToShow")
        
        pfRoundObj?.saveInBackgroundWithBlock {
            (success: Bool!, error: NSError!) -> Void in
            if (success != nil)
            {
                // round was created successfully
            }
            else
            {
                NSLog("%@", error)
            }
        }
    }
    
    func setTargetColor()
    {
        var randomNum = Int(arc4random_uniform(UInt32(Constants.Colors.NumberOfColors)))
        targetColorID = randomNum
        
        if(randomNum == Constants.Colors.ColorRed)
        {
            targetColor = UIColor.redColor()
        }
        else if(randomNum == Constants.Colors.ColorBlue)
        {
            targetColor = UIColor.whiteColor()
        }
        else
        {
            targetColor = UIColor.greenColor()
        }
    }
}