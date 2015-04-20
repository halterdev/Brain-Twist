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
        
        PFInstallation.currentInstallation().setObject(user, forKey: "User")
        PFInstallation.currentInstallation().save()
        
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
        userCoins.setValue(Constants.Users.MaxCoins, forKey: "Coins")
        userCoins.setValue(true, forKey: "IsFull")
        userCoins.setValue(NSDate(), forKey: "LastCoinGenerated")
        
        userCoins.save()
    }
    
    /**
        Add a coin to the User's UserCoins row
    
        :param: user PFUser
    */
    static func AddCoinToUserCoins(#user: PFUser)
    {
        var userCoins = PFObject(className: "UserCoins")
        
        var query = PFQuery(className: "UserCoins")
        query.whereKey("User", equalTo: user)
        
        var userCoinRow = query.getFirstObject()
        
        var coins = userCoinRow.valueForKey("Coins") as! Int
        coins = coins + 1
        
        userCoinRow.setValue(coins, forKey: "Coins")
        userCoinRow.setValue(NSDate(), forKey: "LastCoinGenerated")
        userCoinRow.save()
    }
    
    static func getUsernameWithObjectId(id: String) -> String
    {
        var result: String
        
        var query = PFQuery(className: PFUser.parseClassName())
        query.whereKey("objectId", equalTo: id)
        
        var user = query.getFirstObject() as! PFUser
        
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
        
        var gamesPlayed = (winnerStats.valueForKey("GamesPlayed") as! Int) + 1
        var wins = (winnerStats.valueForKey("Wins") as! Int) + 1
        
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
        
        var gamesPlayed = (loserStats.valueForKey("GamesPlayed") as! Int) + 1
        var losses = (loserStats.valueForKey("Losses") as! Int) + 1
        
        loserStats.setValue(gamesPlayed, forKey: "GamesPlayed")
        loserStats.setValue(losses, forKey: "Losses")
        loserStats.save()
    }
    
    /**
        Subtract a Coin from the User's Coin total
    
        :param: user PFUser
    */
    static func SubtractCoin(#user: PFUser)
    {
        var query = PFQuery(className: "UserCoins")
        query.whereKey("User", equalTo: user)
        
        var coinRow = query.getFirstObject()
        
        var coins = coinRow.valueForKey("Coins") as! Int
        
        if(coins == 5)
        {
            coinRow.setValue(NSDate(), forKey: "LastCoinGenerated")
        }
        
        coinRow.setValue(coins - 1, forKey: "Coins")
        coinRow.save()
    }
    
    /** 
        Get the number of Coins a User has
        
        :param: user PFUser
        :returns: coins Int
    */
    static func GetUsersCoinCount(#user: PFUser) -> Int
    {
        var result = 0
        
        var query = PFQuery(className: "UserCoins")
        query.whereKey("User", equalTo: user)
        
        var coinRow = query.getFirstObject()
        
        result = coinRow.valueForKey("Coins") as! Int
        return result
    }
    
    /**
        Get a User's stat row
    
        :param: user PFUser
        :returns: stat PFObject
    */
    static func GetUsersStatRow(#user: PFUser) -> PFObject
    {
        var query = PFQuery(className: "UserStats")
        query.whereKey("User", equalTo: user)
        
        return query.getFirstObject()
    }
    
    /**
        Get LastCoinGenerated date from User's UserCoins row
    
        :param: user PFUser
    */
    static func GetCoinLastGeneratedTime(#user: PFUser) -> NSDate
    {
        var query = PFQuery(className: "UserCoins")
        query.whereKey("User", equalTo: user)
        
        var coinRow = query.getFirstObject()
        
        return coinRow.valueForKey("LastCoinGenerated") as! NSDate
    }
}