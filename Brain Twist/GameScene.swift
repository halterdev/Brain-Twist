//
//  GameScene.swift
//  Brain Twist
//
//  Created by Jim Halter on 3/1/15.
//  Copyright (c) 2015 HalterDev. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
   
    var viewController: GameViewController
    
    var game: Game
    
    var time: CFTimeInterval?
    var timeToAddNewObject: Double?
    
    var dismissed: Bool
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoder not supported")
    }
    
    init(size: CGSize, viewController: GameViewController) {
        
        dismissed = false
        
        game = Game()
        
        self.viewController = viewController
        
        super.init(size: size)
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        if(game.isFinished && !dismissed)
        {
            dismissGame()
            dismissed = true
        }
        
        if(game.started && !game.isFinished)
        {
            if(game.running)
            {
                if(shouldAddNewObject(currentTime: currentTime) && !game.roundOver)
                {
                    game.addSquare(Square(currentTime: currentTime))
                    
                    while(game.doesNewObjectIntersectAnotherObject())
                    {
                        // as long as Object just added intersects another Object on screen,
                        // continue to change its coordinates until it fits
                        game.squares[game.squares.count - 1].generateXYCoords()
                    }
                }
            
                drawObjectsToScreen(currentTime: currentTime)
            }
            else
            {
                // game hasn't actually started running yet, need to show the label that tells
                // what to touch for a little bit, then dismiss and start game
                
                if(time == nil)
                {
                    time = currentTime
                }
                else
                {
                    if((currentTime - time!) > 2.5)
                    {
                        viewController.fadeOutSelectLabel()
                        game.runGame()
                        game.resetTimeToAddNewObject()
                    }
                }
            }
        }
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        if(game.running)
        {
            for touch in touches
            {
                let thisTouch = touch as! UITouch
                let location = thisTouch.locationInNode(self)
                let touchedNode = nodeAtPoint(location)
                touchedNode.position = location
                
                var touchedObj = game.objectTouched(touch: location)
                
                if(touchedObj != nil)
                {
                    var wasCorrectTouch = game.wasCorrectSquareTouched(square: touchedObj!)
                }
            }
        }
    }
    
    /**
        Setup a new game
    */
    func setupGame()
    {
        game.startGame();
        
        viewController.setSelectLabel(select: game.getSelectLabel())
    }
    
    /**
        Determine whether or not a new object needs to be added to the game
        
        :param: currentTime The current time of the game
        :returns: True or false, whether to create an object or not
    */
    func shouldAddNewObject(#currentTime: CFTimeInterval) -> Bool
    {
        var result = false
        
        if(time != nil)
        {
            if(game.timeToAddNewObject > Constants.Game.MaximumSecondsForObject)
            {
                game.timeToAddNewObject = Constants.Game.MaximumSecondsForObject
            }
            
            if((currentTime - time!) > game.timeToAddNewObject!)
            {
                result = true
                time = currentTime
                game.resetTimeToAddNewObject()
            }
        }
        else
        {
            result = false
            time = currentTime
            game.resetTimeToAddNewObject()
        }
        
        return result
    }
    
    /**
        Draw the game's objects to the screen
    */
    func drawObjectsToScreen(#currentTime: CFTimeInterval)
    {
        self.removeAllChildren()
        
        var done = false
        
        for square in game.squares
        {
            if(!square.dead)
            {
                if(!square.drawnYet)
                {
                    square.drawnYet = true
                    
                    if(game.isSquareCorrect(square: square))
                    {
                        game.correctObjectsShown++
                    }
                }
                
                if(game.correctObjectsShown < game.currentRound.getNumberOfCorrectObjectsToDraw())
                {
                    self.addChild(square.getSquare())
                }
            }
            else
            {
                if(game.getNumberOfSquaresOnScreen() == 0 &&
                    game.correctObjectsShown >= game.currentRound.getNumberOfCorrectObjectsToDraw())
                {
                    if(!done)
                    {
                        game.updateGameForEndOfCurrentTurn(PFUser.currentUser())
                        UserLogic.SubtractCoin(user: PFUser.currentUser())
                        
                        var opponentId: String?
                        if((game.currentRound.pfRoundObj?.objectForKey("PlayerOne") as! PFUser).objectId == PFUser.currentUser().objectId)
                        {
                            // opponent is playertwo .. if there is a playertwo yet of course
                            if(game.currentRound.pfRoundObj?.objectForKey("PlayerTwo") != nil)
                            {
                                opponentId = (game.currentRound.pfRoundObj!.objectForKey("PlayerTwo") as! PFUser).objectId
                            }
                            else
                            {
                                opponentId = nil
                            }
                        }
                        else
                        {
                            opponentId = (game.currentRound.pfRoundObj!.objectForKey("PlayerOne") as! PFUser).objectId
                        }
                        
                        if(game.currentRound.isRoundOver())
                        {
                            game.currentRound.markRoundFinished()
                            
                            var didPlayerOneWin = false
                            if(game.currentRound.pfRoundObj!.valueForKey("PlayerOneScore") as! Int > game.currentRound.pfRoundObj?.valueForKey("PlayerTwoScore") as! Int)
                            {
                                didPlayerOneWin = true
                            }
                            
                            GameLogic.IncreaseWinsOfGame(game: game, didPlayerOneWin: didPlayerOneWin)
                            
                            if(!game.isThisGameCompleteNow())
                            {
                                RoundLogic.createNewRoundForGame(game: game)
                                GameLogic.UpdateRoundNumberOfGame(game: game)
                                
                                if(opponentId != nil)
                                {
                                    UserLogic.SendEndOfRoundPushNotification(opponentId: opponentId!)
                                }
                            }
                            else
                            {
                                GameLogic.SetGameIsFinished(game: game)
                                GameLogic.SetWinnerOfGame(game: game)
                            }
                        }
                        else
                        {
                            if(game.currentRound.pfRoundObj?.valueForKey("PlayerTwo") != nil)
                            {
                                // send notification at this point to opponent if there is one
                                if(opponentId != nil)
                                {
                                    UserLogic.SendEndOfRoundPushNotification(opponentId: opponentId!)
                                }
                            }
                        }
                        done = true
                    }
                    
                    game.isFinished = true
                }
            }
            
            // if square has outlasted its time, kill it so it isn't drawn next update
            if(square.hasSquarePassedTimeToStay(currentTime: currentTime))
            {
                square.kill()
            }
        }
    }
    
    func dismissGame()
    {
        game.removeAllSquares()
        viewController.killGameScene()
        viewController.dismissViewControllerAnimated(true, completion: nil)
    }
}
