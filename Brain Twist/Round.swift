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
    
    /**
        Set a random Target Color for the Objects in this Rounds
    */
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
            targetColor = UIColor.blueColor()
        }
        else
        {
            targetColor = UIColor.greenColor()
        }
    }
    
    /**
        Return the number of correct Objects that are to be drawn for this Round
        
        :return: numberOfObjects Int
    */
    func getNumberOfCorrectObjectsToDraw() -> Int
    {
        var result = 0
        
        if(pfRoundObj != nil)
        {
            result = pfRoundObj?.valueForKey("NumberOfCorrectObjectsToShow") as Int
        }
        
        return result
    }
}