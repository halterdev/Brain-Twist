//
//  GameLogic.swift
//  Brain Twist
//
//  Created by Jim Halter on 3/19/15.
//  Copyright (c) 2015 HalterDev. All rights reserved.
//

import Foundation

struct GameLogic
{
    /**
        Update a Game's RoundNumber
        
        :param: game Game
    */
    static func UpdateRoundNumberOfGame(#game: Game)
    {
        var roundNum = game.pfGameObj!.valueForKey("RoundNumber") as Int
        roundNum++
        
        game.pfGameObj!.setValue(roundNum, forKey: "RoundNumber")
        game.pfGameObj!.save()
    }
    
    /**
        Set a Game to be Finished
        
        :param game Game
    */
    static func SetGameIsFinished(#game: Game)
    {
        game.pfGameObj!.setValue(true, forKey: "IsFinished")
        game.pfGameObj!.save()
    }
    
    /**
        Increase the wins of a Game based on winning PFUser
    
        :param: game Game
        :param: didPlayerOneWin Bool
    */
    static func IncreaseWinsOfGame(#game: Game, didPlayerOneWin: Bool)
    {
        if(didPlayerOneWin)
        {
            var p1Score = game.pfGameObj!.valueForKey("PlayerOneWins") as Int
            p1Score++
            game.pfGameObj!.setValue(p1Score, forKey: "PlayerOneWins")
            game.pfGameObj!.save()
        }
        else
        {
            var p2Score = game.pfGameObj!.valueForKey("PlayerTwoWins") as Int
            p2Score++
            game.pfGameObj!.setValue(p2Score, forKey: "PlayerTwoWins")
            game.pfGameObj!.save()
        }
    }
    
    /**
        Determine and set the winning PFUser of the Game
        
        :param: game Game
    */
    static func SetWinnerOfGame(#game: Game)
    {
        var p1 = game.pfGameObj!.valueForKey("PlayerOne") as PFUser
        var p2 = game.pfGameObj!.valueForKey("PlayerTwo") as PFUser
        
        var p1Wins = game.pfGameObj!.valueForKey("PlayerOneWins") as Int
        var p2Wins = game.pfGameObj!.valueForKey("PlayerTwoWins") as Int
        
        if(p1Wins > p2Wins)
        {
            game.pfGameObj!.setObject(p1, forKey: "Winner")
        }
        else
        {
            game.pfGameObj!.setObject(p2, forKey: "Winner")
        }
        
        game.pfGameObj!.save()
    }
    
}