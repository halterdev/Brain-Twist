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
    @IBOutlet weak var txtConfirmPassword: UITextField!
    
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    @IBOutlet weak var lblError: UILabel!
    
    var mainController: MainMenuViewController!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "bkground.png")!)
        
        txtEmail.backgroundColor = GameLogic.UIColorFromRGB("FFECE8", alpha: 1.0)
        txtUsername.backgroundColor = GameLogic.UIColorFromRGB("FFECE8", alpha: 1.0)
        txtPassword.backgroundColor = GameLogic.UIColorFromRGB("FFECE8", alpha: 1.0)
        txtConfirmPassword.backgroundColor = GameLogic.UIColorFromRGB("FFECE8", alpha: 1.0)
        
        var emailPadding = UIView(frame: CGRectMake(0, 0, 5, 20))
        txtEmail.leftView = emailPadding
        txtEmail.leftViewMode = UITextFieldViewMode.Always
        
        var usernamePadding = UIView(frame: CGRectMake(0, 0, 5, 20))
        txtUsername.leftView = usernamePadding
        txtUsername.leftViewMode = UITextFieldViewMode.Always
        
        var passwordPadding = UIView(frame: CGRectMake(0, 0, 5, 20))
        txtPassword.leftView = passwordPadding
        txtPassword.leftViewMode = UITextFieldViewMode.Always
        
        var cpasswordPadding = UIView(frame: CGRectMake(0, 0, 5, 20))
        txtConfirmPassword.leftView = cpasswordPadding
        txtConfirmPassword.leftViewMode = UITextFieldViewMode.Always
        
        btnRegister.backgroundColor = GameLogic.UIColorFromRGB("FEB09E", alpha: 1.0)
    }
    
    @IBAction func btnRegisterPress(sender: AnyObject)
    {
        if(txtEmail.text != "" && txtUsername.text != "" && txtPassword.text != "" && txtConfirmPassword.text != "")
        {
            var result = UserLogic.register(email: txtEmail.text, username: txtUsername.text, password: txtPassword.text, vc: self)
            if(result)
            {
                // successful login
                self.performSegueWithIdentifier("registeredSegue", sender: self)
            }
            else
            {
                lblError.text = "Email or Username is already used"
                lblError.hidden = false
            }
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