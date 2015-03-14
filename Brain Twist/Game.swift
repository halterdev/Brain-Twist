//
//  Game.swift
//  Brain Twist
//
//  Created by Jim Halter on 3/1/15.
//  Copyright (c) 2015 HalterDev. All rights reserved.
//

import Foundation
import UIKit

class Game
{
    var pfGameObj: PFObject?
    
    var started: Bool
    var running: Bool

    var score: Int
    var correctObjectsShown: Int
    
    var squares: [Square]
    
    var currentRound: Round
    var roundOver: Bool
    
    var timeToAddNewObject: Double?
    
    /**
        Default init for a Game
    */
    init()
    {
        started = false
        running = false
        
        score = 0
        correctObjectsShown = 0
        
        currentRound = Round()
        roundOver = false
        
        squares = [Square]()
    }
    
    /**
        Create a new Game PFObject for the Game
    */
    func createGamePFObject()
    {
        pfGameObj = PFObject(className: "Game")
        
        pfGameObj?.setObject(PFUser.currentUser(), forKey: "PlayerOne")
        pfGameObj?.saveInBackgroundWithBlock {
            (success: Bool!, error: NSError!) -> Void in
            if (success != nil)
            {
                // game object was successfully created, now create its round obj
                self.currentRound.game = self
                self.currentRound.createRoundPFObject(pfGameObj: self.pfGameObj!)
            }
            else
            {
                NSLog("%@", error)
            }
        }
    }
    
    /**
        Set the Game's PFObject
    
        :param: game PFObject
    */
    func setGameObject(#pfGameObj: PFObject)
    {
        self.pfGameObj = pfGameObj
    }
    
    /**
        Add a Square to the array of Squares in the Game
        
        :param: Square - The Square to add to the array
    */
    func addSquare(square: Square) -> Square
    {
        squares.append(square)
        return square
    }
    
    /**
        Generate the text for the label that tells a user what to select 
        for the current Round of the Game
    
        :returns: String Text for label
    */
    func getSelectLabel() -> String
    {
        var color = ""
        
        if(currentRound.targetColor? != nil)
        {
            if(currentRound.targetColor! == UIColor.redColor())
            {
                color = "Red"
            }
            else if(currentRound.targetColor! == UIColor.blueColor())
            {
                color = "Blue"
            }
            else
            {
                color = "Green"
            }
        }
        
        return "Tap the \(color) squares!"
    }
    
    /**
        Start the Game
    */
    func startGame()
    {
        started = true
    }
    
    /**
        Start the Game Running
    */
    func runGame()
    {
        running = true
    }
    
    /**
        Add an Object to the Game
    */
    func addObject(#currentTime: CFTimeInterval)
    {
        squares.append(Square(currentTime: currentTime))
    }
    
    /**
        Return an object if one was touched
    
        :param: touch A CGPoint that represents the touch on the screen
        :returns: Object that was touched or nil if nothing was touched
    */
    func objectTouched(#touch: CGPoint) -> Square?
    {
        var result: Square?
        
        for(var i = 0; i < squares.count; i++)
        {
            var square = squares[i]
            if(square.getFrame().contains(touch))
            {
                square.touched()
                result = square
            }
        }
        
        if(result != nil)
        {
            if(wasCorrectSquareTouched(square: result!))
            {
                updateGameForCorrectObjectTouch()
            }
            else
            {
                updateGameForIncorrectObjectTouch()
            }
        }
        
        return result
    }
    
    /**
        Determine whether or not the Square that was touched on the screen
        was a correct Square
    
        :param: Square The Square that was touched
        :returns: Bool - Was the Square Correct
    */
    func wasCorrectSquareTouched(#square: Square) -> Bool
    {
        var result = false
        
        if(currentRound.targetColor != nil)
        {
            if(square.color == currentRound.targetColor)
            {
                result = true;
            }
        }
        else if (currentRound.targetShape != nil)
        {
            
        }
        else
        {
            
        }
        
        return result
    }
    
    /**
        Set the amount of time should pass before new Object is added to Game
    */
    func resetTimeToAddNewObject()
    {
        var divideBy = Double(arc4random_uniform(UInt32((Constants.Game.MaxDivideForSecondsToAdd)))) + 0.1
        timeToAddNewObject = Constants.Game.MaximumSecondsForObject / divideBy
    }
    
    /**
        Update the Game based on the User selecting a correct Object
    */
    func updateGameForCorrectObjectTouch()
    {
        score++
    }
    
    /**
        Update the Game based on the User selecting an incorrect Object
    */
    func updateGameForIncorrectObjectTouch()
    {
        score--
    }
    
    /**
        Determine whether a newly created Object is going to intersect an Object that is
        already in the Game and alive
    
        :return: bool True if any Objects intersect
    */
    func doesNewObjectIntersectAnotherObject() -> Bool
    {
        var result = false
        var newObject = squares[squares.count - 1]
        
        for(var i = 0; i < squares.count - 2; i++)
        {
            var square = squares[i]
            if(!square.dead)
            {
                if(newObject.getFrame().intersects(square.getFrame()))
                {
                    result = true
                }
            }
        }
        
        return result
    }
    
    /**
        Determine whether a Square is the correct Square for the round
        
        :param: square Square
        :return: bool True if correct Square for current Round
    */
    func isSquareCorrect(#square: Square) -> Bool
    {
        var result = false
        
        if(currentRound.targetColor != nil)
        {
            if(square.color == currentRound.targetColor)
            {
                result = true;
            }
        }
        else if (currentRound.targetShape != nil)
        {
            
        }
        else
        {
            
        }
        
        return result
    }
    
    /**
        Return the number of Squares that are current on the screen
    
        :return: squaresOnScreen Int
    */
    func getNumberOfSquaresOnScreen() -> Int
    {
        var count = 0
        
        for(var i = 0; i < squares.count; i++)
        {
            var square = squares[i]
            if(square.drawnYet && !square.dead)
            {
                count++
            }
        }
        
        return count
    }
    
    /**
        End the current turn
    */
    func endTurn()
    {
        
    }
}