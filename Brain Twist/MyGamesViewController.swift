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
    
    @IBOutlet weak var coinsView: UIView!
    @IBOutlet weak var coin1: UIImageView!
    @IBOutlet weak var coin2: UIImageView!
    @IBOutlet weak var coin3: UIImageView!
    @IBOutlet weak var coin4: UIImageView!
    @IBOutlet weak var coin5: UIImageView!
    
    @IBOutlet weak var btnPurchaseCoins: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.backgroundColor = GameLogic.UIColorFromRGB("AA4F39", alpha: 1.0)
        
        btnNewGame.layer.cornerRadius = 10
        btnNewGame.clipsToBounds = true
        btnNewGame.backgroundColor = GameLogic.UIColorFromRGB("FEB09E", alpha: 1.0)
        
        tblMyTurn.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tblMyTurn.tableFooterView = UIView(frame: CGRectZero)
        tblMyTurn.layer.cornerRadius = 10
        tblMyTurn.clipsToBounds = true
        tblMyTurn.backgroundColor = GameLogic.UIColorFromRGB("FFECE8", alpha: 1.0)
        
        tblTheirTurn.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cellopponent")
        tblTheirTurn.tableFooterView = UIView(frame: CGRectZero)
        tblTheirTurn.tableFooterView = UIView(frame: CGRectZero)
        tblTheirTurn.layer.cornerRadius = 10
        tblTheirTurn.clipsToBounds = true
        tblTheirTurn.backgroundColor = GameLogic.UIColorFromRGB("FFECE8", alpha: 1.0)
        
        coinsView.backgroundColor = GameLogic.UIColorFromRGB("FFECE8", alpha: 1.0)
        coinsView.layer.cornerRadius = 10
        coinsView.clipsToBounds = true
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
        if(tableView == tblMyTurn)
        {
            var query = PFQuery(className: "Game")
            query.whereKey("objectId", equalTo: myTurnGameIds![indexPath.row])
            
            var gameObj = query.getFirstObject()
            
            var vc = self.storyboard?.instantiateViewControllerWithIdentifier("vcGame") as GameViewController
            vc.pfGameObj = gameObj
            
            self.presentViewController(vc, animated: true, completion: nil)
        }
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
        query.whereKeyExists("PlayerTwo")
        
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
        query.whereKeyExists("PlayerTwo")
        
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
        theirTurnStrings = nil
        
        tblMyTurn.reloadData()
        tblTheirTurn.reloadData()
        
        loadMyTurns()
        loadTheirTurns()
        
        setCoins()
    }
    
    private func hideYoureTableInfo()
    {
        tblMyTurn.hidden = true
        
        lblYoureTurn.hidden = false
        lblYoureTurn.text = "Start a New Game!"
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
    
    private func setCoins()
    {
        var coins = UserLogic.GetUsersCoinCount(user: PFUser.currentUser())
        
        if(coins == 5)
        {
            coin1.hidden = false
            coin2.hidden = false
            coin3.hidden = false
            coin4.hidden = false
            coin5.hidden = false
        }
        else if (coins == 4)
        {
            coin1.hidden = false
            coin2.hidden = false
            coin3.hidden = false
            coin4.hidden = false
            
            coin5.hidden = true
        }
        else if (coins == 3)
        {
            coin1.hidden = false
            coin2.hidden = false
            coin3.hidden = false
            
            coin4.hidden = true
            coin5.hidden = true
        }
        else if (coins == 2)
        {
            coin1.hidden = false
            coin2.hidden = false
            
            coin3.hidden = true
            coin4.hidden = true
            coin5.hidden = true
        }
        else if (coins == 1)
        {
            coin1.hidden = false
            
            coin2.hidden = true
            coin3.hidden = true
            coin4.hidden = true
            coin5.hidden = true
        }
        else
        {
            coin1.hidden = true
            coin2.hidden = true
            coin3.hidden = true
            coin4.hidden = true
            coin5.hidden = true
            
            btnPurchaseCoins.hidden = false
        }
    }
    
    @IBAction func btnNewGamePressed(sender: AnyObject)
    {
        var coins = UserLogic.GetUsersCoinCount(user: PFUser.currentUser())
        
        if(coins > 0)
        {
            var vc = self.storyboard?.instantiateViewControllerWithIdentifier("vcGame") as GameViewController
            self.presentViewController(vc, animated: true, completion: nil)
        }
        else
        {
            
        }
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