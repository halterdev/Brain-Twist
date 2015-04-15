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
        static let squareHeight = 55.0
        static let squareWidth = 55.0
        
        static let minX = squareWidth
        static let minY = squareHeight
        
        static let maxX = (375.0 - squareWidth)
        static let maxY = (667.0 - squareHeight)
        
        static let MaxTimeToLive = 2.2
        static let MinimumTimeToLive = 0.2
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
        
        static let FontColorRed = 0
        static let FontColorBlue = 1
        static let FontColorGreen = 2
        
        static let NumberOfColors = 3
    }
    
    struct Game
    {
        static let MaximumSecondsForObject = 0.7
        static let MaxDivideForSecondsToAdd = 3.5
        
        static let NumberOfRounds = 3
        
        static let NumberOfCorrectObjectsToShowPerRound = 10
    }
    
    struct Users
    {
        static let MaxCoins = 5
        static let MinsToNextCoin = 5
    }
}