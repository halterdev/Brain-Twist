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
    
    @IBOutlet weak var tblMyTurn: UITableView!
    
    var myTurnGameIds: [String]?
    var myTurnStrings: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblMyTurn.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
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
                
                if(self.myTurnGameIds == nil)
                {
                    self.myTurnGameIds = [String]()
                    self.myTurnStrings = [String]()
                }
                
                self.myTurnGameIds?.append(game.objectId)
                self.myTurnStrings?.append("Test")
            }
            self.tblMyTurn.reloadData()
        }
    }
    
    @IBAction func btnNewGamePressed(sender: AnyObject)
    {
        var vc = self.storyboard?.instantiateViewControllerWithIdentifier("vcGame") as GameViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
}