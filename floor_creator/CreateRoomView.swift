//
//  CreateRoomView.swift
//  floor_creator
//
//  Created by Mark Reimer on 10/1/14.
//  Copyright (c) 2014 Shy Ward. All rights reserved.
//

import Foundation
import UIKit

class CreateRoomView: UIView {

    var captureButton: UIButton = UIButton();
    var title: UILabel = UILabel();
    
    let arrowNorth = UIImage(named: "CircleArrow");
    let arrowNorth_on = UIImage(named: "CircleArrow_on");
    let arrowNorthArray: [UIImage]!
    let checkmark = UIImage(named: "checkmark");
    
    var imgView_arrowNorth: UIImageView!
    
    // represents a measurement from somewhere inside the room to the wall on the north side of the room, in cm.
    // the height of the room is distanceToNorthWall + distanceToSouthWall
    var distanceToNorthWall: Int = 0;
    
    // represents a measurement from somewhere inside the room to the south facing wall, in cm.
    // the height of the room is distanceToNorthWall + distanceToSouthWall
    var distanceToSouthWall: Int = 0;
    
    // represents a measurement from somewhere inside the room to the east facing wall, in cm.
    // the width of the room is distanceToEastWall + distanceToWestWall
    var distanceToEastWall: Int = 0;
    
    // represents a measurement from somewhere inside the room to the west facing wall, in cm.
    // the width of the room is distanceToEastWall + distanceToWestWall
    var distanceToWestWall: Int = 0;
    
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        // set border and background color
        self.backgroundColor = UIColor.whiteColor();
        self.layer.borderWidth = 2.0;
        self.layer.borderColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0.1, 0.1, 0.1, 0.1]);
        
        var labelRect = CGRect(x: 0, y: 20.0, width: self.frame.size.width, height: 20.0);
        title.frame = labelRect;
        title.textAlignment = NSTextAlignment.Center;
        title.textColor = UIColor.grayColor();
        title.text = "Point to the first wall and click capture";
        self.addSubview(title);
        
        // draw the arrow images
        let arrowNorthArray: [UIImage] = [arrowNorth, arrowNorth_on];
        
        imgView_arrowNorth = UIImageView();
        imgView_arrowNorth.animationImages = arrowNorthArray;
        imgView_arrowNorth.animationDuration = 1.0;
        var arrowNorthImgRect = CGRect( x: self.frame.size.width/2 - arrowNorth.size.width/2,
                                        y: 100,
                                        width: arrowNorth.size.width,
                                        height: arrowNorth.size.height);
        imgView_arrowNorth?.frame = arrowNorthImgRect;
        self.addSubview(imgView_arrowNorth);
        imgView_arrowNorth.startAnimating();
        
        // draw the capture circle button
        captureButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton;
        captureButton.setTitle("capture", forState: .Normal);
        captureButton.setTitleColor(UIColor.orangeColor(), forState: .Normal);
        captureButton.titleLabel?.font = UIFont(name:"Helvetica", size: 14.0)
        captureButton.addTarget(self, action: "capture:", forControlEvents: .TouchUpInside);
        var captureButtonRect = CGRect(x: 5, y: self.frame.size.height/2, width: 64.0, height: 64.0);
        captureButton.frame = captureButtonRect;
        captureButton.clipsToBounds = true;
        captureButton.layer.cornerRadius = 64.0/2.0;
        captureButton.layer.borderColor = UIColor.orangeColor().CGColor;
        captureButton.layer.borderWidth = 2.0;
        self.addSubview(captureButton);
        
        

    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }

    
    
    func capture(sender: UIButton!) {
        println("capture button clicked.");
    }
    
    override func drawRect(rect: CGRect) {

    }

    
    // Utility routine to convert cm to feet and inches
    func cmToFeetInches(cm: Int) -> String {
        var inches: Float = Float(cm) / 2.54;
        var feet: Int = Int(inches)  / 12;
        
        inches = inches - (12 * Float(feet));
        return String(format: "%d' %.1f\"", feet, inches);
    }
    
       
    
}