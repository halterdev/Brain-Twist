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
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnNotRegistered: UIButton!
    @IBOutlet weak var btnGames: UIButton!
    
    var user: PFUser?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

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
            txtUsername.hidden = true
            txtPassword.hidden = true
            btnLogin.hidden = true
            btnNotRegistered.hidden = true
            
            btnGames.hidden = false
        }
        else
        {
            // set up screen for someone not logged in
            txtUsername.hidden = false
            txtPassword.hidden = false
            btnLogin.hidden = false
            btnNotRegistered.hidden = false
            
            btnGames.hidden = true
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