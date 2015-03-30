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
    
    var roundNumber: Int
    
    var targetColor: UIColor?
    var targetColorID: Int?
    
    var targetText: String?
    
    init()
    {
        roundNumber = 1
        
        setTargetColor()
    }
    
    init(roundObj: PFObject, game: Game)
    {
        self.game = game
        self.pfRoundObj = roundObj
        
        roundNumber = roundObj.valueForKey("RoundNumber") as Int
        setTargetColor(id: roundObj.valueForKey("TargetColorID") as Int)
        
        if(roundNumber > 1)
        {
            setTargetText(color: roundObj.valueForKey("TargetText") as String)
        }
    }
    
    init(roundNumber: Int, isPlayerOne: Bool)
    {
        self.roundNumber = roundNumber
        
        setTargetColor()
    }
    
    init(game: Game)
    {
        self.game = game
        roundNumber = 0
        
        loadCurrentRoundPFObject()
        
        roundNumber = pfRoundObj?.valueForKey("RoundNumber") as Int
    }
    
    init(game: Game, amIAddingANewRound: Bool)
    {
        self.game = game
        roundNumber = game.currentRound.roundNumber
        roundNumber++
        
        setTargetColor()
        setTargetText()
    }
    
    
    /**
        Create a PFObject representing the Round
    */
    func createRoundPFObject(#pfGameObj: PFObject, roundNumber: Int, isPlayerOne: Bool)
    {
        pfRoundObj = PFObject(className: "Round")
        
        pfRoundObj?.setObject(pfGameObj, forKey: "Game")
        pfRoundObj?.setValue(roundNumber, forKey: "RoundNumber")
        
        if(isPlayerOne)
        {
            pfRoundObj?.setObject(PFUser.currentUser(), forKey: "PlayerOne")
            pfRoundObj?.setObject(game?.pfGameObj?.valueForKey("PlayerTwo"), forKey: "PlayerTwo")
        }
        else
        {
            pfRoundObj?.setObject(game?.pfGameObj?.valueForKey("PlayerOne"), forKey: "PlayerOne")
            pfRoundObj?.setObject(PFUser.currentUser(), forKey: "PlayerTwo")
        }
        
        pfRoundObj?.setValue(false, forKey: "HasPlayerOnePlayed")
        pfRoundObj?.setValue(false, forKey: "HasPlayerTwoPlayed")
        pfRoundObj?.setObject(PFUser.currentUser(), forKey: "TurnPlayer")
        pfRoundObj?.setValue(0, forKey: "PlayerOneScore")
        pfRoundObj?.setValue(0, forKey: "PlayerTwoScore")
        pfRoundObj?.setValue(targetColorID, forKey: "TargetColorID")
        pfRoundObj?.setValue(Constants.Game.NumberOfCorrectObjectsToShowPerRound, forKey: "NumberOfCorrectObjectsToShow")
        pfRoundObj?.setValue(false, forKey: "IsFinished")
        
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
        Set Target Color with a Target Color ID
    */
    func setTargetColor(#id: Int)
    {
        if(id == Constants.Colors.ColorRed)
        {
            targetColor = UIColor.redColor()
        }
        else if(id == Constants.Colors.ColorBlue)
        {
            targetColor = UIColor.blueColor()
        }
        else
        {
            targetColor = UIColor.greenColor()
        }
    }
    
    /**
        Set a random Target Text for the Objects in this Round
    */
    func setTargetText()
    {
        var randomNum = Int(arc4random_uniform(UInt32(Constants.Colors.NumberOfColors)))
        targetColorID = randomNum
        
        if(randomNum == Constants.Colors.ColorRed)
        {
            targetText = "Red"
        }
        else if(randomNum == Constants.Colors.ColorBlue)
        {
            targetText = "Blue"
        }
        else
        {
            targetText = "Green"
        }
    }
    
    /**
        Set the Target Text with a Target Tex ID
    */
    func setTargetText(#color: String)
    {
        targetText = color
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
    
    /**
        Load current PFObject Round of Game
    */
    func loadCurrentRoundPFObject()
    {
        var query = PFQuery(className: "Round")
        query.whereKey("Game", equalTo: self.game)
        query.whereKey("CurrentRound", equalTo: self.game?.pfGameObj?.valueForKey("CurrentRound"))
        
        var pfRound = query.getFirstObject()
        self.pfRoundObj = pfRound
    }
    
    /**
        Determine whether or not the Round is over
    */
    func isRoundOver() -> Bool
    {
        var result = false
        
        var hasPlayerOnePlayed = pfRoundObj?.valueForKey("HasPlayerOnePlayed") as Bool
        var hasPlayerTwoPlayed = pfRoundObj?.valueForKey("HasPlayerTwoPlayed") as Bool
        
        if(hasPlayerOnePlayed && hasPlayerTwoPlayed)
        {
            result = true
        }
        
        return result
    }
    
    /**
        Mark the Round as Finished
    */
    func markRoundFinished()
    {
        RoundLogic.markRoundFinished(round: pfRoundObj!)
    }
    
    /**
        Get the CurrentRound number of the Round
    */
    func getCurrentRoundNumber() -> Int
    {
        return pfRoundObj?.valueForKey("RoundNumber") as Int
    }
}