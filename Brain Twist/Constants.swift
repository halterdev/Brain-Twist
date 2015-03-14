//
//  Constants.swift
//  Brain Twist
//
//  Created by Jim Halter on 3/1/15.
//  Copyright (c) 2015 HalterDev. All rights reserved.
//

import Foundation

struct Constants
{
    struct Square
    {
        static let squareHeight = 45.0
        static let squareWidth = 45.0
        
        static let minX = 35.0
        static let minY = 35.0
        
        static let maxX = 345.0
        static let maxY = 635.0
        
        static let MaxTimeToLive = 1.5
        static let MinimumTimeToLive = 0.5
    }
    
    struct Scale
    {
        static let iPhone6 = 1.0
    }
    
    struct Colors
    {
        static let ColorRed = 0
        static let ColorBlue = 1
        static let ColorGreen = 2
        
        static let NumberOfColors = 3
    }
    
    struct Game
    {
        static let MaximumSecondsForObject = 3.0
        static let MaxDivideForSecondsToAdd = 10
    }
}