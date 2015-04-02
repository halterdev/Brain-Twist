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
    
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var lblError: UILabel!
    
    var mainController: MainMenuViewController!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = GameLogic.UIColorFromRGB("AA4F39", alpha: 1.0)
        
        txtEmail.backgroundColor = GameLogic.UIColorFromRGB("FFECE8", alpha: 1.0)
        txtUsername.backgroundColor = GameLogic.UIColorFromRGB("FFECE8", alpha: 1.0)
        txtPassword.backgroundColor = GameLogic.UIColorFromRGB("FFECE8", alpha: 1.0)
        
        btnRegister.layer.cornerRadius = 10
        btnRegister.clipsToBounds = true
        btnRegister.backgroundColor = GameLogic.UIColorFromRGB("FEB09E", alpha: 1.0)
        
        btnCancel.layer.cornerRadius = 10
        btnCancel.clipsToBounds = true
        btnCancel.backgroundColor = GameLogic.UIColorFromRGB("FEB09E", alpha: 1.0)
    }
    
    @IBAction func btnRegisterPress(sender: AnyObject)
    {
        var result = UserLogic.register(email: txtEmail.text, username: txtUsername.text, password: txtPassword.text, vc: self)
        if(result)
        {
            // successful login
            //mainController.setMainMenu(loggedIn: true)
            
            self.performSegueWithIdentifier("registeredSegue", sender: self)
            //self.dismissViewControllerAnimated(true, completion: nil)
        }
        else
        {
            lblError.hidden = false
        }
    }
    
    @IBAction func btnCancelPressed(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}