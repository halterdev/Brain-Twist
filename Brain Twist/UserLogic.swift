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
        user.setValue(0, forKey: "GamesPlayed")
        user.setValue(0, forKey: "Wins")
        user.setValue(0, forKey: "Losses")
        user.setValue(5, forKey: "Coins")
        
        result = user.signUp()
        
        return result
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
        var gamesPlayed = user.valueForKey("GamesPlayed") as Int
        gamesPlayed = gamesPlayed++
        
        var wins = user.valueForKey("Wins") as Int
        wins = wins++
        
        user.setValue(wins, forKey: "Wins")
        user.setValue(gamesPlayed, forKey: "GamesPlayed")
        user.save()
    }
    
    /**
        Add a Loss to a User's Losses
    */
    static func AddLoss(#user: PFUser)
    {
        var gamesPlayed = user.valueForKey("GamesPlayed") as Int
        gamesPlayed = gamesPlayed++
        
        var losses = user.valueForKey("Losses") as Int
        losses = losses++
        
        user.setValue(losses, forKey: "Losses")
        user.setValue(gamesPlayed, forKey: "GamesPlayed")
        user.save()
    }
}