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
    let π = CGFloat(M_PI);
    
    var captureButton: UIButton = UIButton();
    var title: UILabel = UILabel();
    var distanceLabel: UILabel = UILabel();
    
    let arrow = UIImage(named: "CircleArrow");
    let arrow_on = UIImage(named: "CircleArrow_on");
    let arrowArray: [UIImage]!
    let checkmark = UIImage(named: "checkmark");
    
    var imgView_North: UIImageView!
    var imgView_South: UIImageView!
    var imgView_East: UIImageView!
    var imgView_West: UIImageView!
    
    var rangefinder: Rangefinder!
    
    // keeps track of which wall is being measured
    enum Direction {
        case NORTH
        case EAST
        case SOUTH
        case WEST
    }
    
    // stores the distance value in cm
    var distance: Int! = 0;
    
    var currentDirection: Direction = .NORTH;
    
    // represents a measurement from somewhere inside the room to the wall on the north side of the room, in cm.
    // the height of the room is distanceToNorthWall + distanceToSouthWall
    var distanceToNorthWall = 0;
    
    // represents a measurement from somewhere inside the room to the south facing wall, in cm.
    // the height of the room is distanceToNorthWall + distanceToSouthWall
    var distanceToSouthWall = 0;
    
    // represents a measurement from somewhere inside the room to the east facing wall, in cm.
    // the width of the room is distanceToEastWall + distanceToWestWall
    var distanceToEastWall = 0;
    
    // represents a measurement from somewhere inside the room to the west facing wall, in cm.
    // the width of the room is distanceToEastWall + distanceToWestWall
    var distanceToWestWall = 0;
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        // instantiate Rangefinder and start video capture
        rangefinder = Rangefinder();
        
        currentDirection = .NORTH;
        
        // set border and background color
        self.backgroundColor = UIColor.whiteColor();
        self.layer.borderWidth = 2.0;
        self.layer.borderColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0.1, 0.1, 0.1, 0.1]);
        
        // add the labels
        var labelRect = CGRect(x: 0, y: 20.0, width: self.frame.size.width, height: 20.0);
        title.frame = labelRect;
        title.textAlignment = NSTextAlignment.Center;
        title.textColor = UIColor.blueColor();
        title.text = "Point to the first wall and click capture";
        
        labelRect = CGRect(x: 0, y: 180.0, width: self.frame.size.width, height: 50.0);
        distanceLabel.frame = labelRect;
        distanceLabel.textAlignment = NSTextAlignment.Center;
        distanceLabel.textColor = UIColor.blackColor();
        distanceLabel.font = UIFont(name:"Helvetica", size: 28.0)
        distanceLabel.text = "";
        
        self.addSubview(title);
        self.addSubview(distanceLabel);
        
        // draw the arrow images
        let arrowArray: [UIImage] = [arrow, arrow_on];
        
        imgView_North = UIImageView();
        imgView_North.animationImages = arrowArray;
        imgView_North.animationDuration = 1.0;
        var northImgRect = CGRect(  x: self.frame.size.width/2 - arrow.size.width/2,
                                    y: 100,
                                    width: arrow.size.width,
                                    height: arrow.size.height);
        imgView_North?.frame = northImgRect;
        self.addSubview(imgView_North);
        imgView_North.startAnimating();
        
        imgView_East = UIImageView();
        imgView_East.animationImages = arrowArray;
        imgView_East.animationDuration = 1.0;
        var eastImgRect = CGRect(   x: self.frame.size.width/2 + arrow.size.width,
                                    y: 110 + arrow.size.height,
                                    width: arrow.size.width,
                                    height: arrow.size.height);
        imgView_East?.frame = eastImgRect;
        // rotate the arrow image by 90˚
        imgView_East.transform = CGAffineTransformMakeRotation(π/2);
        
        imgView_South = UIImageView();
        imgView_South.animationImages = arrowArray;
        imgView_South.animationDuration = 1.0;
        var southImgRect = CGRect(  x: self.frame.size.width/2 - arrow.size.width/2,
                                    y: 120 + arrow.size.height*2,
                                    width: arrow.size.width,
                                    height: arrow.size.height);
        imgView_South?.frame = southImgRect;
        // rotate the arrow image by 90˚
        imgView_South.transform = CGAffineTransformMakeRotation(π);

        imgView_West = UIImageView();
        imgView_West.animationImages = arrowArray;
        imgView_West.animationDuration = 1.0;
        var westImgRect = CGRect(   x: self.frame.size.width/2 - 2 * arrow.size.width,
                                    y: 110 + arrow.size.height,
                                    width: arrow.size.width,
                                    height: arrow.size.height);
        imgView_West?.frame = westImgRect;
        // rotate the arrow image by 90˚
        imgView_West.transform = CGAffineTransformMakeRotation(-π/2);

        
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

        // kick off background queue
        startRangefinderUpdateThread();
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }


    // background queue for updating rangefinder distance on this view
    func startRangefinderUpdateThread() {
        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT;
        let rangefinder_queue: dispatch_queue_t! = dispatch_queue_create("com.adt.innovation.floor_plan.rangefinder", nil);
        
        dispatch_async(rangefinder_queue, { ()->() in
            // sleep for a bit to let the rangefinder finish initializing
            sleep(2);
            
            println("\(self.rangefinder.isRunning)");
            while (self.rangefinder.isRunning) {
                sleep(1);
                self.displayDistance(Int(self.rangefinder.distance));
            }
        });
    }

    
    // saves distance reading and prepares the view to capture the next distance measurement
    func capture(sender: UIButton!) {
        
        // save to instance property
        switch currentDirection {
        
        case .SOUTH:
            distanceToSouthWall = distance!;
        case .EAST:
            distanceToEastWall = distance!;
        case .NORTH:
            distanceToNorthWall = distance!;
        case .WEST:
            distanceToWestWall = distance!;
        }
        
        displayNextDirection();
    }
    
    override func drawRect(rect: CGRect) {
        
    }
   
    func displayDistance(distance: Int) {
        // display distance in the label
        self.distance = distance;
        self.distanceLabel.text = self.cmToFeetInches(self.distance!);
    }
    
    // draws the appropriate view for capturing the next wall measurement
    func displayNextDirection() {
        switch currentDirection {
        case .SOUTH:
            currentDirection = .WEST
            
            // update help text
            title.text = "Almost Done!";
            
            // unrotate image
            imgView_South.transform = CGAffineTransformMakeRotation(2*π);
            
            imgView_South.stopAnimating();
            imgView_South.image = checkmark;
            self.addSubview(imgView_West);
            imgView_West.startAnimating();
        case .EAST:
            currentDirection = .SOUTH
            
            // update help text 
            title.text = "Keep Going. Two more walls to measure.";
            
            // unrotate image
            imgView_East.transform = CGAffineTransformMakeRotation(2*π);
            
            imgView_East.stopAnimating();
            imgView_East.image = checkmark;
            self.addSubview(imgView_South);
            imgView_South.startAnimating();
        case .NORTH:
            currentDirection = .EAST;
            
            // update help text
            title.text = "Excellent! Now point to the next wall and click capture";
            
            imgView_North.stopAnimating();
            imgView_North.image = checkmark;
            self.addSubview(imgView_East);
            imgView_East.startAnimating();
        case .WEST:
            currentDirection = .NORTH
            
            // update help text
            title.text = "Congratulations! You've measured this room.";
            
            // unrotate image
            imgView_West.transform = CGAffineTransformMakeRotation(-2*π);
            
            imgView_West.stopAnimating();
            imgView_West.image = checkmark;
            // all done with this room
        }
    }
    
    // Utility routine to convert cm to feet and inches
    func cmToFeetInches(cm: Int) -> String {
        var inches: Float = Float(cm) / 2.54;
        var feet: Int = Int(inches)  / 12;
        
        inches = inches - (12 * Float(feet));
        return String(format: "%d' %.1f\"", feet, inches);
    }

    
}

