//
//  GameLogic.swift
//  Brain Twist
//
//  Created by Jim Halter on 3/15/15.
//  Copyright (c) 2015 HalterDev. All rights reserved.
//

import Foundation

class GameLogic
{
    /**
        Create a new Game PFObject
    */
    func createGamePFObject(#game: Game)
    {
        var pfGameObj = PFObject(className: "Game")
        
        pfGameObj?.setObject(PFUser.currentUser(), forKey: "PlayerOne")
        pfGameObj?.saveInBackgroundWithBlock {
            (success: Bool!, error: NSError!) -> Void in
            if (success != nil)
            {
                // game object was successfully created, now create its round obj
                game.currentRound.game = game
                game.currentRound.createRoundPFObject(pfGameObj: pfGameObj)
            }
            else
            {
                NSLog("%@", error)
            }
        }
    }
}