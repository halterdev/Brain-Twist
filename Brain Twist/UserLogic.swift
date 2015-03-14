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
    static func register(#email: String, #username: String, #password: String) -> String
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
}