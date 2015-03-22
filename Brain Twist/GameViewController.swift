//
//  GameViewController.swift
//  Brain Twist
//
//  Created by Jim Halter on 3/1/15.
//  Copyright (c) 2015 HalterDev. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    @IBOutlet weak var lblScore: UILabel!
    @IBOutlet weak var lblSelectThis: UILabel!
    
    var gameScene: GameScene!
    var skView: SKView!
    
    var pfGameObj: PFObject?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        lblScore.text = "Score: 0"
        lblScore.hidden = false

        // Create and configure the scene.
        skView = self.view as SKView
        gameScene = GameScene(size: skView.bounds.size, viewController: self)
        gameScene.scaleMode = .AspectFill

        gameScene.viewController = self
        
        if(pfGameObj == nil)
        {
            gameScene.game.createGamePFObject()
        }
        else
        {
            gameScene.game.setupGameWithPFObject(pfGameObj: pfGameObj!)
            gameScene.game.getAndAssignRound()
        }

        // Present the scene.
        skView.presentScene(gameScene)
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent)
    {
        if(skView.scene as? GameScene != nil)
        {
            lblScore.text = "Score: \(gameScene.game.score)"
        }
        
    }

    override func prefersStatusBarHidden() -> Bool
    {
        return true
    }
    
    func setSelectLabel(#select: String)
    {
        lblSelectThis.hidden = false
        lblSelectThis.text = select
    }
    
    func fadeOutSelectLabel()
    {
        lblSelectThis.hidden = true
    }
    
    func killGameScene()
    {
        self.gameScene = nil
    }
}
