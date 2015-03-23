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
    static func register(#email: String, username: String, password: String) -> String
    {
        var result = ""
        var user = PFUser()
        
        user.email = email
        user.username = username
        user.password = password
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool!, error: NSError!) -> Void in
            if error == nil {
                // user was successfully registered
                
            } else {
                // error w/ registration
                result = error.debugDescription
            }
        }
        
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
}