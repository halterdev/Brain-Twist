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
    
    init(#roundNumber: Int, #isPlayerOne: Bool)
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
    
    
    /**
        Create a PFObject representing the Round
    */
    func createRoundPFObject(#pfGameObj: PFObject, #roundNumber: Int, #isPlayerOne: Bool)
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
        pfRoundObj?.setValue(7, forKey: "NumberOfCorrectObjectsToShow")
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
        Update the Round based on the end of a turn
    */
    func updateRoundForEndOfTurn()
    {
        var playerOne = pfRoundObj?.valueForKey("PlayerOne") as PFUser
        var playerTwo = pfRoundObj?.valueForKey("PlayerTwo") as PFUser
        
        if(playerOne == PFUser.currentUser())
        {
            // player one finished turn
            
            pfRoundObj?.setValue(true, forKey: "HasPlayerOnePlayed")
            pfRoundObj?.setValue(game?.score, forKey: "PlayerOneScore")
            pfRoundObj?.setObject(playerTwo, forKey: "TurnPlayer")
        }
        else
        {
            // player two finished turn
            
            pfRoundObj?.setValue(true, forKey: "HasPlayerTwoPlayed")
            pfRoundObj?.setValue(game?.score, forKey: "PlayerTwoScore")
            pfRoundObj?.setObject(playerOne, forKey: "TurnPlayer")
        }
        
        pfRoundObj?.save()
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
        Get the CurrentRound number of the Round
    */
    func getCurrentRoundNumber() -> Int
    {
        return pfRoundObj?.valueForKey("CurrentRound") as Int
    }
}