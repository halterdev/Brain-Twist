//
//  MainTextField.swift
//  Brain Twist
//
//  Created by Jim Halter on 3/31/15.
//  Copyright (c) 2015 HalterDev. All rights reserved.
//

import Foundation
import UIKit

class MainTextField: UITextField
{
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 5.0;
        self.layer.borderColor = UIColor.grayColor().CGColor
        self.layer.borderWidth = 1.5
        self.backgroundColor = UIColor.blueColor()
        self.textColor = UIColor.whiteColor()
        self.tintColor = UIColor.purpleColor()
    }
}