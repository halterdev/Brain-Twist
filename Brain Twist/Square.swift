//
//  Square.swift
//  Brain Twist
//
//  Created by Jim Halter on 3/1/15.
//  Copyright (c) 2015 HalterDev. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class Square
{
    var text: SKLabelNode!
    var color: UIColor!
    
    var x: Double
    var y: Double
    
    var width: Double
    var height: Double
    
    var scale: Double
    
    var timeToLive: Double
    
    var timeBorn: CFTimeInterval
    
    var drawnYet: Bool
    var dead: Bool
    
    /**
        Create a new Square object
    */
    init(currentTime: CFTimeInterval)
    {
        x = 0.0
        y = 0.0
        
        width = Constants.Square.squareWidth
        height = Constants.Square.squareHeight
        
        scale = Constants.Scale.iPhone6
        
        timeToLive = Double(arc4random_uniform(UInt32(Constants.Square.MaxTimeToLive))) + Constants.Square.MinimumTimeToLive
        timeBorn = currentTime
        
        drawnYet = false
        dead = false
        
        setColor()
        
        generateXYCoords()
        generateText()
    }
    
    /**
        Return the shape of the square to draw to the screen
        
        :returns: An SKShapeNode that represents the square
    */
    func getSquare() -> SKShapeNode
    {
        var square = SKShapeNode(rect: CGRect(x: x, y: y, width: width * scale, height: height * scale))
        square.fillColor = color
        square.addChild(text)
        
        var textNode = (square.children[0] as! SKLabelNode)
        textNode.position = generateCGPointForLabel()
        
        return square
    }
    
    /**
        Return the frame of the square
    
        :returns: CGRect of the square
    */
    func getFrame() -> CGRect
    {
        return CGRect(x: x, y: y, width: width * scale, height: height * scale)
    }
    
    /**
        Set the color of the Square
    */
    func setColor()
    {
        var randomNum = Int(arc4random_uniform(UInt32(Constants.Colors.NumberOfColors)))
        
        if(randomNum == Constants.Colors.ColorRed)
        {
            color = UIColor.redColor()
        }
        else if (randomNum == Constants.Colors.ColorBlue)
        {
            color = UIColor.blueColor()
        }
        else
        {
            color = UIColor.greenColor()
        }
    }
    
    /**
        Kill the square after it has been touched
    */
    func touched()
    {
        dead = true
    }
    
    /**
        Kill the square if it has been on screen too long
    */
    func kill()
    {
        dead = true
        zeroOutValues()
    }
    
    /**
        Eliminate a square from the screen
    */
    func zeroOutValues()
    {
        x = 0
        y = 0
        height = 0
        width = 0
    }
    
    /**
        If the Square has been on the screen longer than its time to be on, return true
        
        :returns: bool
    */
    func hasSquarePassedTimeToStay(#currentTime: CFTimeInterval) -> Bool
    {
        var result = false
        
        if(timeBorn.distanceTo(currentTime) > timeToLive)
        {
            result = true
        }
        
        return result
    }
    
    /**
        Generate the Square's x, y coordinates
    */
    func generateXYCoords()
    {
        x = Double(arc4random_uniform(UInt32(Constants.Square.maxX)))
        y = Double(arc4random_uniform(UInt32(Constants.Square.maxY)))
    }
    
    /**
        Generate CGPoint for label inside a square
    
        :return: point CGPoint
    */
    func generateCGPointForLabel() -> CGPoint
    {
        var labelX: Double
        var labelY: Double
        labelX = x + (Constants.Square.squareWidth / 2)
        labelY = y + (Constants.Square.squareHeight / 3)
        
        var point = CGPoint(x: labelX, y: labelY)
        return point
    }
    
    /**
        Generate the Square's text
    */
    func generateText()
    {
        var num = arc4random_uniform(3)
        
        if(num == 0)
        {
            text = SKLabelNode(text: "Red")
        }
        else if (num == 1)
        {
            text = SKLabelNode(text: "Blue")
        }
        else if(num == 2)
        {
            text = SKLabelNode(text: "Green")
        }
        else
        {
            text = SKLabelNode(text: "Orange")
        }
        
        text.fontSize = 15
        text.fontName = "AvenirNext-Bold";
        
        var randomNum = Int(arc4random_uniform(2))
        if(color == UIColor.redColor())
        {
            if(randomNum == 0)
            {
                text.fontColor = SKColor.blueColor()
            }
            else
            {
                text.fontColor = SKColor.greenColor()
            }
        }
        else if (color == UIColor.blueColor())
        {
            if(randomNum == 0)
            {
                text.fontColor = SKColor.redColor()
            }
            else
            {
                text.fontColor = SKColor.greenColor()
            }
        }
        else
        {
            if(randomNum == 0)
            {
                text.fontColor = SKColor.redColor()
            }
            else
            {
                text.fontColor = SKColor.blueColor()
            }
        }
    }
}