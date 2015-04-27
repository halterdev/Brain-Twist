//
//  RoundLogic.swift
//  Brain Twist
//
//  Created by Jim Halter on 3/18/15.
//  Copyright (c) 2015 HalterDev. All rights reserved.
//

import Foundation

struct RoundLogic
{
    /**
        Get Round PFObject from db based on a Game PFObject
    
        :param: game PFObject
        :return: PFObject
    */
    static func getRoundPFObject(#game: PFObject) -> PFObject
    {
        var query = PFQuery(className: "Round")
        query.whereKey("RoundNumber", equalTo: game.valueForKey("RoundNumber"))
        query.whereKey("Game", equalTo: game)
        
        var roundObj = query.getFirstObject()
        return roundObj as PFObject
    }
    
    /**
        Mark a Round as finished
        
        :param: round PFObject
    */
    static func markRoundFinished(#round: PFObject)
    {
        round.setValue(true, forKey: "IsFinished")
        round.save()
    }
    
    /**
        Create new Round for Game
        
        :param: game Game
        :return: Round
    */
    static func createNewRoundForGame(#game: Game) -> Round
    {
        var newRound = Round(game: game, amIAddingANewRound: true)
        
        var round = PFObject(className: "Round")
        round.setObject(game.pfGameObj!, forKey: "Game")
        round.setValue(newRound.roundNumber, forKey: "RoundNumber")
        round.setObject(game.pfGameObj?.valueForKey("PlayerOne"), forKey: "PlayerOne")
        round.setObject(game.pfGameObj?.valueForKey("PlayerTwo"), forKey: "PlayerTwo")
        round.setValue(false, forKey: "HasPlayerOnePlayed")
        round.setValue(false, forKey: "HasPlayerTwoPlayed")
        round.setObject(game.pfGameObj?.valueForKey("PlayerOne"), forKey: "TurnPlayer")
        round.setValue(0, forKey: "PlayerOneScore")
        round.setValue(0, forKey: "PlayerTwoScore")
        round.setValue(newRound.targetColorID, forKey: "TargetColorID")
        round.setValue(newRound.targetText, forKey: "TargetText")
        round.setValue(Constants.Game.NumberOfCorrectObjectsToShowPerRound, forKey: "NumberOfCorrectObjectsToShow")
        round.setValue(false, forKey: "IsFinished")
        
        round.save()
        return newRound
    }
    
    /**
        Update Round for the end of a turn
        
        :param: round Round
    */
    static func UpdateRoundForEndOfTurn(#game: Game, user: PFUser)
    {
        var pfRoundObj = PFObject(className: "Round")
        pfRoundObj = game.currentRound.pfRoundObj
        
        var playerOne = pfRoundObj!.valueForKey("PlayerOne") as! PFUser
        
        if(playerOne.objectId == user.objectId)
        {
            // player one finished turn
            pfRoundObj!.setValue(true, forKey: "HasPlayerOnePlayed")
            pfRoundObj!.setValue(game.score, forKey: "PlayerOneScore")
            
            if(pfRoundObj!.valueForKey("PlayerTwo") != nil)
            {
                pfRoundObj!.setObject(pfRoundObj!.valueForKey("PlayerTwo") as! PFUser, forKey: "TurnPlayer")
            }
        }
        else
        {
            // player two finished turn
            pfRoundObj!.setValue(true, forKey: "HasPlayerTwoPlayed")
            pfRoundObj!.setValue(game.score, forKey: "PlayerTwoScore")
            pfRoundObj!.setObject(playerOne, forKey: "TurnPlayer")
        }
        
        pfRoundObj.save()
    }
    
    /**
        Generate the bottom string of a My Turns table cell
        This String will tell a User if they are winning, losing or tied 
        
        :param: user PFUser
        :param: gameId String
        :return: String
    */
    static func GetBottomTextForMyTurnCell(#user: PFUser, gameId: String) -> String
    {
        var result = ""
        
        var query = PFQuery(className: "Game")
        query.whereKey("objectId", equalTo: gameId)
        
        var game = query.getFirstObject() as PFObject
        var roundNum = game.valueForKey("RoundNumber") as! Int
        
        var roundQuery = PFQuery(className: "Round")
        roundQuery.whereKey("Game", equalTo: game)
        roundQuery.whereKey("RoundNumber", equalTo: roundNum)
        
        var roundObj = roundQuery.getFirstObject()
        
        var playerOne = roundObj.objectForKey("PlayerOne") as! PFUser
        var playerTwo = roundObj.objectForKey("PlayerTwo") as! PFUser
        
        var playerOneWins = game.valueForKey("PlayerOneWins") as! Int
        var playerTwoWins = game.valueForKey("PlayerTwoWins") as! Int
        
        var isPlayerOne = playerOne.objectId == user.objectId
        
        if(playerOneWins != playerTwoWins)
        {
            // game is not tied
            if(playerOneWins > playerTwoWins)
            {
                if(isPlayerOne)
                {
                    result = "You are winning \(playerOneWins)-\(playerTwoWins)"
                }
                else
                {
                    result = "You are losing \(playerOneWins)-\(playerTwoWins)"
                }
            }
            else
            {
                if(isPlayerOne)
                {
                    result = "You are losing \(playerTwoWins)-\(playerOneWins)"
                }
                else
                {
                    result = "You are winning \(playerTwoWins)-\(playerOneWins)"
                }
            }
        }
        else
        {
            // game is tied
            result = "Game is tied \(playerOneWins)-\(playerTwoWins)"
        }
        
        return result
    }
}