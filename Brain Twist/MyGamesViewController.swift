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
    
    var coinTimer: NSTimer?
    //var coinLastGenerated: NSDate?
    var coinMins: Int?
    var coinSeconds: Int?
    
    @IBOutlet weak var lblCoinTimer: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("setCoins"), name: UIApplicationWillEnterForegroundNotification, object: nil)
        
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
        
        lblNoGames.text = ""
        lblNoGames.hidden = true
        
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
                // formatting the cells of my turns table here
                
                let font = UIFont(name: "Arial", size: 14.0) ?? UIFont.systemFontOfSize(10.0)
                let regFont = [NSFontAttributeName:font]
                
                let fontItal = UIFont(name: "Georgia-Italic", size: 10.0) ?? UIFont.systemFontOfSize(10.0)
                let italFont = [NSFontAttributeName:fontItal]
                
                let string = NSMutableAttributedString()
                
                let topString = NSAttributedString(string: self.myTurnStrings![indexPath.row] + "\n", attributes: regFont)
                let bottomString = NSAttributedString(string: RoundLogic.GetBottomTextForMyTurnCell(user: PFUser.currentUser(), gameId: self.myTurnGameIds![indexPath.row]), attributes:italFont)
                
                string.appendAttributedString(topString)
                string.appendAttributedString(bottomString)
                
                cell.textLabel?.numberOfLines = 0
                cell.textLabel?.attributedText = string
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
                if(playerOne.objectId != PFUser.currentUser().objectId)
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
            
            if(self.segment.selectedSegmentIndex == 0)
            {
                if(rounds.count == 0)
                {
                    self.setNoGamesLabel(myTurns: true)
                    self.tblMyTurn.hidden = true
                }
                else
                {
                    self.tblMyTurn.hidden = false
                    self.lblNoGames.hidden = true
                }
            }
            
            self.tblMyTurn.reloadData()
        }
    }
    
    /**
        Fill the array with all of the ROunds where it is the turn of the user's opponent
    */
    func loadTheirTurns()
    {
        var withOpponent = PFQuery(className: "Round")
        withOpponent.whereKey("TurnPlayer", notEqualTo: PFUser.currentUser())
        withOpponent.whereKeyExists("PlayerTwo")
        
        
        var noOpponentYet = PFQuery(className: "Round")
        noOpponentYet.whereKey("PlayerOne", equalTo: PFUser.currentUser())
        noOpponentYet.whereKeyDoesNotExist("PlayerTwo")
        
        
        var query = PFQuery.orQueryWithSubqueries([withOpponent, noOpponentYet])
        query.includeKey("Game")
        query.whereKey("IsFinished", equalTo: false)
        
        query.findObjectsInBackgroundWithBlock
            {
                (rounds: [AnyObject]!, error: NSError!) -> Void in
                for round in rounds
                {
                    var thisRound = round as! PFObject
                    var game = thisRound.objectForKey("Game") as! PFObject
                    
                    var roundNumber = game.valueForKey("RoundNumber") as! Int
                    
                    var playerOne = game.objectForKey("PlayerOne") as! PFUser
                    var playerTwo = game.objectForKey("PlayerTwo") as? PFUser
                    
                    if(playerTwo != nil)
                    {
                        var opponent: PFUser
                        var opponentName: String
                        if(playerOne.objectId != PFUser.currentUser().objectId)
                        {
                            opponent = playerOne
                        }
                        else
                        {
                            opponent = playerTwo!
                        }
                        opponentName = UserLogic.getUsernameWithObjectId(opponent.objectId)
                        
                        if(self.theirTurnStrings == nil)
                        {
                            self.theirTurnStrings = [String]()
                        }
                        
                        self.theirTurnStrings?.append("Round \(roundNumber) vs \(opponentName)")
                    }
                    else
                    {
                        if(self.theirTurnStrings == nil)
                        {
                            self.theirTurnStrings = [String]()
                        }
                        
                        self.theirTurnStrings?.append("Waiting for an Opponent...")
                    }
                }
                
                if(self.segment.selectedSegmentIndex == 1)
                {
                    if(rounds.count == 0)
                    {
                        self.setNoGamesLabel(myTurns: false)
                        self.tblTheirTurn.hidden = true
                    }
                    else
                    {
                        self.tblTheirTurn.hidden = false
                        self.lblNoGames.hidden = true
                    }
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
        
        lblNoGames.hidden = true
        lblNoGames.text = ""
        
        tblMyTurn.hidden = true
        tblTheirTurn.hidden = true
        
        tblMyTurn.reloadData()
        tblTheirTurn.reloadData()
        
        loadMyTurns()
        loadTheirTurns()
    }
    
    private func setNoGamesLabel(#myTurns: Bool)
    {
        if(myTurns)
        {
            lblNoGames.text = "You do not have any turns"
            lblNoGames.hidden = false
            tblMyTurn.hidden = true
        }
        else
        {
            lblNoGames.text = "You are not waiting on anybody"
            lblNoGames.hidden = false
            tblTheirTurn.hidden = true
        }
    }
    
    func setCoins()
    {
        var coins = UserLogic.GetUsersCoinCount(user: PFUser.currentUser())
        
        if(coins == 5)
        {
            coin1.hidden = false
            coin2.hidden = false
            coin3.hidden = false
            coin4.hidden = false
            coin5.hidden = false
            
            lblCoinTimer.hidden = true
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
            
            if(coinTimer == nil)
            {
                coinTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("subtractTime"), userInfo: nil, repeats: true)
            }
        }
    }
    
    func subtractTime()
    {
        var done = false
        
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
                coinTimer?.invalidate()
            }
        }
        else
        {
            coinSeconds!--
        }
        
        if(!done)
        {
            if(coinSeconds < 10)
            {
                lblCoinTimer.text = "\(coinMins!):" + "0\(coinSeconds!)"
            }
            else
            {
                lblCoinTimer.text = "\(coinMins!):" + "\(coinSeconds!)"
            }
            lblCoinTimer.hidden = false
        }
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