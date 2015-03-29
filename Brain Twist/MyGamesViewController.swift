//
//  MyGamesViewController.swift
//  Brain Twist
//
//  Created by Jim Halter on 3/11/15.
//  Copyright (c) 2015 HalterDev. All rights reserved.
//

import Foundation
import UIKit

class MyGamesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate
{
    @IBOutlet weak var btnNewGame: UIButton!
    
    @IBOutlet weak var lblYoureTurn: UILabel!
    @IBOutlet weak var lblTheirTurn: UILabel!
    
    @IBOutlet weak var tblMyTurn: UITableView!
    @IBOutlet weak var tblTheirTurn: UITableView!
    
    var myTurnGameIds: [String]?
    var myTurnStrings: [String]?
    
    var theirTurnStrings: [String]?
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        
        tblMyTurn.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tblMyTurn.tableFooterView = UIView(frame: CGRectZero)
        
        tblTheirTurn.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cellopponent")
        tblTheirTurn.tableFooterView = UIView(frame: CGRectZero)
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell: UITableViewCell
        
        if(tableView == tblMyTurn)
        {
            cell = self.tblMyTurn.dequeueReusableCellWithIdentifier("cell") as UITableViewCell
            
            if(myTurnStrings != nil)
            {
                cell.textLabel?.text = self.myTurnStrings![indexPath.row]
            }
        }
        else
        {
            cell = self.tblTheirTurn.dequeueReusableCellWithIdentifier("cellopponent") as UITableViewCell
            
            if(theirTurnStrings != nil)
            {
                cell.textLabel?.text = self.theirTurnStrings![indexPath.row]
            }
        }
    
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if(tableView == tblMyTurn)
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
        else
        {
            if(theirTurnStrings == nil)
            {
                return 0
            }
            else
            {
                return theirTurnStrings!.count
            }
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
            
            if(self.myTurnGameIds? != nil && self.myTurnGameIds?.count > 0)
            {
                self.showYoureTableInfo()
            }
            else
            {
                self.hideYoureTableInfo()
            }
        }
    }
    
    /**
        Fill the array with all of the ROunds where it is the turn of the user's opponent
    */
    func loadTheirTurns()
    {
        var query = PFQuery(className: "Round")
        query.includeKey("Game")
        query.whereKey("TurnPlayer", notEqualTo: PFUser.currentUser())
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
                    
                    if(self.theirTurnStrings == nil)
                    {
                        self.theirTurnStrings = [String]()
                    }
                    
                    self.theirTurnStrings?.append("Round \(roundNumber) vs \(opponentName)")
                }
                
                self.tblTheirTurn.reloadData()
                
                if(self.theirTurnStrings? != nil && self.theirTurnStrings?.count > 0)
                {
                    self.showTheirTableInfo()
                }
                else
                {
                    self.hideTheirTableInfo()
                }
            }
    }
    
    override func viewWillAppear(animated: Bool)
    {
        
        myTurnGameIds = nil
        myTurnStrings = nil
        
        loadMyTurns()
        loadTheirTurns()
    }
    
    private func hideYoureTableInfo()
    {
        lblYoureTurn.hidden = true
        tblMyTurn.hidden = true
    }
    private func showYoureTableInfo()
    {
        lblYoureTurn.hidden = false
        tblMyTurn.hidden = false
    }
    private func hideTheirTableInfo()
    {
        lblTheirTurn.hidden = true
        tblTheirTurn.hidden = true
    }
    private func showTheirTableInfo()
    {
        lblTheirTurn.hidden = false
        tblTheirTurn.hidden = false
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
    
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        if (scrollView.contentOffset.x != 0)
        {
            var offset = scrollView.contentOffset;
            offset.x = 0;
            scrollView.contentOffset = offset;
        }

    }
}