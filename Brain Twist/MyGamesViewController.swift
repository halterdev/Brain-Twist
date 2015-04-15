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
    @IBOutlet weak var lblNoGames: UILabel!
    
    var myTurnGameIds: [String]?
    var myTurnStrings: [String]?
    
    var theirTurnStrings: [String]?
    
    var showAd = false
    
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var segment: UISegmentedControl!
    
    @IBOutlet weak var coinsView: UIView!
    @IBOutlet weak var coin1: UIImageView!
    @IBOutlet weak var coin2: UIImageView!
    @IBOutlet weak var coin3: UIImageView!
    @IBOutlet weak var coin4: UIImageView!
    @IBOutlet weak var coin5: UIImageView!
    
    @IBOutlet weak var btnPurchaseCoins: UIButton!
    
    var coinTimer = NSTimer()
    //var coinLastGenerated: NSDate?
    var coinMins: Int?
    var coinSeconds: Int?
    
    @IBOutlet weak var lblCoinTimer: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bkground.png")!)
        
        topView.backgroundColor = GameLogic.UIColorFromRGB("FEB09E", alpha: 1.0)
        
        btnNewGame.layer.cornerRadius = 10
        btnNewGame.clipsToBounds = true
        btnNewGame.backgroundColor = UIColor.whiteColor()
        
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
        
        coinsView.backgroundColor = UIColor.whiteColor()
        coinsView.layer.cornerRadius = 10
        coinsView.clipsToBounds = true
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell: UITableViewCell
        
        if(tableView == tblMyTurn)
        {
            cell = self.tblMyTurn.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
            
            if(myTurnStrings != nil)
            {
                cell.textLabel?.text = self.myTurnStrings![indexPath.row]
            }
        }
        else
        {
            cell = self.tblTheirTurn.dequeueReusableCellWithIdentifier("cellopponent") as! UITableViewCell
            
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
            
            var vc = self.storyboard?.instantiateViewControllerWithIdentifier("vcGame") as! GameViewController
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
        
        //query.findObjectsInBackgroundWithBlock(<#block: PFArrayResultBlock!##([AnyObject]!, NSError!) -> Void#>)
        query.findObjectsInBackgroundWithBlock
        {
            (rounds: [AnyObject]!, error: NSError!) -> Void in
            for round in rounds
            {
                var thisRound = round as! PFObject
                var game = thisRound.objectForKey("Game") as! PFObject

                var roundNumber = game.valueForKey("RoundNumber") as! Int
                
                var playerOne = game.objectForKey("PlayerOne") as! PFUser
                var playerTwo = game.objectForKey("PlayerTwo") as! PFUser
                
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
                    var thisRound = round as! PFObject
                    var game = thisRound.objectForKey("Game") as! PFObject
                    
                    var roundNumber = game.valueForKey("RoundNumber") as! Int
                    
                    var playerOne = game.objectForKey("PlayerOne") as! PFUser
                    var playerTwo = game.objectForKey("PlayerTwo") as! PFUser
                    
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
            }
    }
    
    @IBAction func segmentChanged(sender: AnyObject)
    {
        setTables()
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
        
        setTables()
        
        setCoins()
        
        if(showAd)
        {
            if(ALInterstitialAd.isReadyForDisplay())
            {
                ALInterstitialAd.show()
            }
        }
    }
    
    private func setTables()
    {
        myTurnGameIds = nil
        myTurnStrings = nil
        theirTurnStrings = nil
        
        tblMyTurn.reloadData()
        tblTheirTurn.reloadData()
        
        loadMyTurns()
        loadTheirTurns()
        
        if(segment.selectedSegmentIndex == 0)
        {
            // my turns selected
            
            if(myTurnGameIds?.count > 0)
            {
                lblNoGames.hidden = true
                tblTheirTurn.hidden = true
                
                tblMyTurn.hidden = false
            }
            else
            {
                lblNoGames.text = "You do not have any turns!"
                lblNoGames.hidden = false
                tblTheirTurn.hidden = true
                tblMyTurn.hidden = true
            }
        }
        else
        {
            // opponents turns selected
            
            if(theirTurnStrings?.count > 0)
            {
                lblNoGames.hidden = true
                tblMyTurn.hidden = true
                
                tblTheirTurn.hidden = false
            }
            else
            {
                lblNoGames.text = "You are not waiting on anybody!"
                lblNoGames.hidden = false
                
                tblMyTurn.hidden = true
                tblTheirTurn.hidden = false
            }
        }
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
            
            //btnPurchaseCoins.hidden = false
        }
        
        if(coins < Constants.Users.MaxCoins)
        {
            setCoinTimer()
        }
        else
        {
            lblCoinTimer.hidden = true
        }
    }
    
    private func setCoinTimer()
    {
        var coinLastGenerated = UserLogic.GetCoinLastGeneratedTime(user: PFUser.currentUser())
        var secondsSinceLastCoin = NSDate().secondsFrom(coinLastGenerated)
        
        if(secondsSinceLastCoin > (60 * Constants.Users.MinsToNextCoin))
        {
            // user is due for a new coin..
            UserLogic.AddCoinToUserCoins(user: PFUser.currentUser())
            setCoins()
        }
        else
        {
            var secondsLeft = (60 * 5) - secondsSinceLastCoin
            
            coinMins = secondsLeft / 60
            coinSeconds = secondsLeft % 60
            
            coinTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("subtractTime"), userInfo: nil, repeats: true)
        }
    }
    
    func subtractTime()
    {
        if(coinSeconds == 0)
        {
            if(coinMins > 0)
            {
                coinMins = coinMins! - 1
                coinSeconds = 59
            }
            else
            {
                UserLogic.AddCoinToUserCoins(user: PFUser.currentUser())
                setCoins()
            }
        }
        else
        {
            coinSeconds!--
        }
        
        lblCoinTimer.text = "\(coinMins!):" + "\(coinSeconds!)"
    }
    
    @IBAction func btnNewGamePressed(sender: AnyObject)
    {
        var coins = UserLogic.GetUsersCoinCount(user: PFUser.currentUser())
        
        if(coins > 0)
        {
            var vc = self.storyboard?.instantiateViewControllerWithIdentifier("vcGame") as! GameViewController
            vc.myGamesVc = self
            
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

extension NSDate
{
    func secondsFrom(date:NSDate) -> Int
    {
        return NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitSecond, fromDate: date, toDate: self, options: nil).second
    }
    
    func offsetFrom(date:NSDate) -> String
    {
        if secondsFrom(date) > 0 { return "\(secondsFrom(date))s" }
        return ""
    }
}