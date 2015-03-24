//
//  MyGamesViewController.swift
//  Brain Twist
//
//  Created by Jim Halter on 3/11/15.
//  Copyright (c) 2015 HalterDev. All rights reserved.
//

import Foundation
import UIKit

class MyGamesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var btnNewGame: UIButton!
    
    @IBOutlet weak var lblYoureTurn: UILabel!
    
    @IBOutlet weak var tblMyTurn: UITableView!
    
    var myTurnGameIds: [String]?
    var myTurnStrings: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblMyTurn.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tblMyTurn.tableFooterView = UIView(frame: CGRectZero)
        
        loadMyTurns()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell:UITableViewCell = self.tblMyTurn.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
        
        if(myTurnStrings != nil)
        {
            cell.textLabel?.text = self.myTurnStrings![indexPath.row]
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(myTurnStrings == nil)
        {
            return 0
        }
        else
        {
            return myTurnStrings!.count
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        var query = PFQuery(className: "Game")
        query.whereKey("objectId", equalTo: myTurnGameIds![indexPath.row])
        
        var gameObj = query.getFirstObject()
        
        var vc = self.storyboard?.instantiateViewControllerWithIdentifier("vcGame") as GameViewController
        vc.pfGameObj = gameObj
        
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    /**
        Fill the array with all of the Games where it is the turn of the current User
    */
    func loadMyTurns()
    {
        var query = PFQuery(className: "Round")
        query.includeKey("Game")
        query.whereKey("TurnPlayer", equalTo: PFUser.currentUser())
        query.whereKey("IsFinished", equalTo: false)
        
        query.findObjectsInBackgroundWithBlock
        {
            (rounds: [AnyObject]!, error: NSError!) -> Void in
            for round in rounds
            {
                var game = round["Game"] as PFObject
                var roundNumber = game.valueForKey("RoundNumber") as Int
                
                var playerOne = game["PlayerOne"] as PFUser
                var playerTwo = game["PlayerTwo"] as PFUser
                
                var opponent: PFUser
                var opponentName: String
                if(playerOne != PFUser.currentUser())
                {
                    opponent = playerOne
                }
                else
                {
                    opponent = playerTwo
                }
                opponentName = UserLogic.getUsernameWithObjectId(opponent.objectId)
                
                if(self.myTurnGameIds == nil)
                {
                    self.myTurnGameIds = [String]()
                    self.myTurnStrings = [String]()
                }
                
                self.myTurnGameIds?.append(game.objectId)
                self.myTurnStrings?.append("Round \(roundNumber) vs \(opponentName)")
            }
            self.tblMyTurn.reloadData()
            
            if(self.myTurnGameIds != nil && self.myTurnGameIds?.count > 0)
            {
                self.lblYoureTurn.hidden = false
                self.tblMyTurn.hidden = false
            }
        }
    }
    
    @IBAction func btnBackPressed(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func btnNewGamePressed(sender: AnyObject)
    {
        var vc = self.storyboard?.instantiateViewControllerWithIdentifier("vcGame") as GameViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
}