//
//  MainMenuViewController.swift
//  Brain Twist
//
//  Created by Jim Halter on 3/10/15.
//  Copyright (c) 2015 HalterDev. All rights reserved.
//

import Foundation

class MainMenuViewController: UIViewController
{
    @IBOutlet weak var topBarView: UIView!
    
    @IBOutlet weak var lblBrainTwist: UILabel!
    
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnNotRegistered: UIButton!
    
    var user: PFUser?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bkground.png")!)
        
        topBarView.backgroundColor = GameLogic.UIColorFromRGB("FEB09E", alpha: 1.0)
        
        lblBrainTwist.textColor = GameLogic.UIColorFromRGB("FFECE8", alpha: 1.0)
        
        txtUsername.backgroundColor = GameLogic.UIColorFromRGB("FFECE8", alpha: 1.0)
        txtPassword.backgroundColor = GameLogic.UIColorFromRGB("FFECE8", alpha: 1.0)
        
        var usernamePadding = UIView(frame: CGRectMake(0, 0, 5, 20))
        txtUsername.leftView = usernamePadding
        txtUsername.leftViewMode = UITextFieldViewMode.Always
        
        var passwordPadding = UIView(frame: CGRectMake(0, 0, 5, 20))
        txtPassword.leftView = passwordPadding
        txtPassword.leftViewMode = UITextFieldViewMode.Always
        
        btnLogin.backgroundColor = GameLogic.UIColorFromRGB("FEB09E", alpha: 1.0)
        
        user = PFUser.currentUser()
        
        setMainMenu(loggedIn: false)
    }
    
    /**
    Set up the buttons that make up the Main Menu
    
    :params: loggedIn Bool - Is there a User logged in?
    */
    func setMainMenu(#loggedIn: Bool)
    {
        if(loggedIn)
        {
            // setup screen for user that is logged in
            lblBrainTwist.hidden = true
            txtUsername.hidden = true
            txtPassword.hidden = true
            btnLogin.hidden = true
            btnNotRegistered.hidden = true
            
        }
        else
        {
            // set up screen for someone not logged in
            lblBrainTwist.hidden = false
            txtUsername.hidden = false
            txtPassword.hidden = false
            btnLogin.hidden = false
            btnNotRegistered.hidden = false
        }
    }
    
    @IBAction func btnLoginPressed(sender: AnyObject)
    {
        PFUser.logInWithUsernameInBackground(txtUsername.text, password:txtPassword.text)
        {
            (user: PFUser!, error: NSError!) -> Void in
                if(user != nil)
                {
                    // successful login
                    self.user = PFUser.currentUser()
                    self.setMainMenu(loggedIn: true)
                    self.performSegueWithIdentifier("loggedInSegue", sender: self)
                }
                else
                {
                    // login failed
                }
        }
    }
    
    @IBAction func btnGamesPressed(sender: AnyObject)
    {
        var vc = self.storyboard?.instantiateViewControllerWithIdentifier("vcMyGames") as MyGamesViewController
        
        //self.dismissViewControllerAnimated(true, completion: nil)
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if(segue.destinationViewController.isKindOfClass(RegisterViewController))
        {
            var vc = segue.destinationViewController as RegisterViewController
            vc.mainController = self
        }
    }
}