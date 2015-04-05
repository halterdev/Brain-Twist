//
//  UserLogic.swift
//  Brain Twist
//
//  Created by Jim Halter on 3/9/15.
//  Copyright (c) 2015 HalterDev. All rights reserved.
//

import Foundation

struct UserLogic
{
    /**
        Insert a new PFUser into the database
    
        :param: email String
        :param: username String
        :param: password String
        :returns: String - Empty if success, otherwise the error
    */
    static func register(#email: String, username: String, password: String, vc: UIViewController) -> Bool
    {
        var result = true
        var user = PFUser()
        
        user.email = email
        user.username = username
        user.password = password
        
        result = user.signUp()
        
        InsertUserStatRow(user: user)
        InsertUserCoinsRow(user: user)
        
        return result
    }
    
    /**
        Insert the User's initial UserStats row for future use
    
        :param: user PFUser
    */
    static func InsertUserStatRow(#user: PFUser)
    {
        var userStats = PFObject(className: "UserStats")
        
        userStats.setObject(user, forKey: "User")
        userStats.setValue(0, forKey: "GamesPlayed")
        userStats.setValue(0, forKey: "Wins")
        userStats.setValue(0, forKey: "Losses")
        userStats.setValue(0, forKey: "Ties")
        
        userStats.save()
    }
    
    /**
        Insert the User's initial UserCoins row
    
        :param: user PFUser
    */
    static func InsertUserCoinsRow(#user: PFUser)
    {
        var userCoins = PFObject(className: "UserCoins")
        
        userCoins.setObject(user, forKey: "User")
        userCoins.setValue(Constants.Game.InitialCoins, forKey: "Coins")
        
        userCoins.save()
    }
    
    static func addUserToWaitList()
    {
        var waitingUser = PFUser()
        var done = false
        
        var query = PFQuery(className: PFUser.parseClassName())
        query.whereKey("username", equalTo: "breezy")
        
        waitingUser = query.getFirstObject() as PFUser
        
        var userWaiting = PFObject(className: "UsersWaitingForGame")
        userWaiting.setObject(waitingUser, forKey: "User")
        userWaiting.save()
        
    }
    
    static func getOpponentFromWaitingList() -> PFUser
    {
        var result = PFUser()
        
        var query = PFQuery(className: "UsersWaitingForGame")
        query.includeKey("User")
        
        var userWaitingForGameRow = query.getFirstObject()
        result = userWaitingForGameRow["User"] as PFUser
        
        return result
    }
    
    static func getUsernameWithObjectId(id: String) -> String
    {
        var result: String
        
        var query = PFQuery(className: PFUser.parseClassName())
        query.whereKey("objectId", equalTo: id)
        
        var user = query.getFirstObject() as PFUser
        
        result = user.username
        return result
    }
    
    /**
        Add a Win to a User's wins
    
        :param: user PFUser
    */
    static func AddWin(#user: PFUser)
    {
        var query = PFQuery(className: "UserStats")
        query.whereKey("User", equalTo: user)
        
        var winnerStats = query.getFirstObject()
        
        var gamesPlayed = (winnerStats.valueForKey("GamesPlayed") as Int) + 1
        var wins = (winnerStats.valueForKey("Wins") as Int) + 1
        
        winnerStats.setValue(gamesPlayed, forKey: "GamesPlayed")
        winnerStats.setValue(wins, forKey: "Wins")
        winnerStats.save()
    }
    
    /**
        Add a Loss to a User's Losses
    */
    static func AddLoss(#user: PFUser)
    {
        var query = PFQuery(className: "UserStats")
        query.whereKey("User", equalTo: user)
        
        var loserStats = query.getFirstObject()
        
        var gamesPlayed = (loserStats.valueForKey("GamesPlayed") as Int) + 1
        var losses = (loserStats.valueForKey("Losses") as Int) + 1
        
        loserStats.setValue(gamesPlayed, forKey: "GamesPlayed")
        loserStats.setValue(losses, forKey: "Losses")
        loserStats.save()
    }
}