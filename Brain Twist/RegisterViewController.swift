//
//  RegisterViewController.swift
//  Brain Twist
//
//  Created by Jim Halter on 3/4/15.
//  Copyright (c) 2015 HalterDev. All rights reserved.
//

import Foundation

class RegisterViewController: UIViewController
{
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var lblEmailStar: UILabel!
    @IBOutlet weak var lblUsernamStar: UILabel!
    @IBOutlet weak var lblPasswordStar: UILabel!
    
    @IBOutlet weak var lblErrorMsg: UILabel!
    
    var mainController: MainMenuViewController!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    @IBAction func btnRegisterPressed(sender: AnyObject)
    {
        
        var result = UserLogic.register(email: txtEmail.text, username: txtUsername.text, password: txtPassword.text)
        if(result == "")
        {
            // successful login
            mainController.setMainMenu(loggedIn: true)
            self.dismissViewControllerAnimated(true, completion: nil)
            self.presentViewController(GameViewController(), animated: true, completion: nil)
        }
    }
    
    @IBAction func btnCancelPressed(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}