//
//  CreateRoomView.swift
//  floor_creator
//
//  Created by Mark Reimer on 10/1/14.
//  Copyright (c) 2014 Shy Ward. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation


class CreateRoomView: UIView, CLLocationManagerDelegate {
    
    // used for keeping track of the direction the user is facing
    var locationManager: CLLocationManager?
    var currentHeading: CLHeading?
    
    // stores the initial heading in radians, after CLLocationManager has initialized
    var initialHeading = 0.0;
    
    let π = CGFloat(M_PI);
    
    var captureButton: UIButton = UIButton();
    var title: UILabel = UILabel();
    var distanceLabel: UILabel = UILabel();
    
    // sub view that the distance label and arrows are on
    var floatingCanvas: UIView = UIView();
    
    let arrow0 = UIImage(named: "arrow-up-0");
    let arrow10 = UIImage(named: "arrow-up-10");
    let arrow20 = UIImage(named: "arrow-up-20");
    let arrow30 = UIImage(named: "arrow-up-30");
    let arrow40 = UIImage(named: "arrow-up-40");
    let arrow50 = UIImage(named: "arrow-up-50");
    let arrow60 = UIImage(named: "arrow-up-60");
    let arrow70 = UIImage(named: "arrow-up-70");
    let arrow80 = UIImage(named: "arrow-up-80");
    let arrow90 = UIImage(named: "arrow-up-90");
    let arrow100 = UIImage(named: "arrow-up-100");
    let checkmark = UIImage(named: "checkmark");
    
    let HELP_TEXT_POINT: String = String("Point to the wall and click capture");
    
    var imgView_North: UIImageView!
    var imgView_South: UIImageView!
    var imgView_East: UIImageView!
    var imgView_West: UIImageView!
    
    var lblDistance_North: UILabel!
    var lblDistance_South: UILabel!
    var lblDistance_East: UILabel!
    var lblDistance_West: UILabel!
    
    var rangefinder: Rangefinder!

    var timer: NSTimer!
    
    // keeps track of which wall is being measured
    enum Direction {
        case NORTH
        case EAST
        case SOUTH
        case WEST
    }
    
    var isRotating: Bool = false;
    
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
        
        // initialize CLLocationManager and heading
        currentHeading = CLHeading();
        locationManager = CLLocationManager();
        if(locationManager!.respondsToSelector("requestAlwaysAuthorization")) {
            locationManager!.requestAlwaysAuthorization();
        }
        locationManager!.delegate = self
        locationManager!.pausesLocationUpdatesAutomatically = false
        locationManager!.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager!.headingFilter = 1;
        locationManager!.startUpdatingHeading();
        
        // set border and background color
        self.backgroundColor = UIColor.whiteColor();
        
        var labelRect = CGRect(x: 0, y: 20.0, width: self.frame.size.width, height: 20.0);
        title.frame = labelRect;
        title.textAlignment = NSTextAlignment.Center;
        title.textColor = UIColor.blackColor();
        title.text = HELP_TEXT_POINT;
        self.addSubview(title);
        
        // floating canvas
        var canvasRect = CGRect(x: self.frame.size.width - 150.0, y: 80.0, width: 300.0, height: 300.0);
        floatingCanvas.frame = canvasRect;
        floatingCanvas.backgroundColor = UIColor.whiteColor();
        floatingCanvas.layer.borderWidth = 2.0;
        floatingCanvas.layer.borderColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0.1, 0.1, 0.1, 0.1]);
        self.addSubview(floatingCanvas);
        
        labelRect = CGRect(x: 0.0, y: floatingCanvas.frame.size.height/2-25, width: floatingCanvas.frame.size.width, height: 50.0);
        distanceLabel.frame = labelRect;
        distanceLabel.textAlignment = NSTextAlignment.Center;
        distanceLabel.textColor = UIColor.blackColor();
        distanceLabel.font = UIFont(name:"Helvetica", size: 24.0);
        distanceLabel.text = "";
        floatingCanvas.addSubview(distanceLabel);
        
        // draw the arrow images and distance labels
        let arrowArray: [UIImage] = [arrow0, arrow10, arrow20, arrow30, arrow40, arrow50, arrow60, arrow70, arrow80, arrow90, arrow100];
        
        imgView_North = UIImageView();
        imgView_North.animationImages = arrowArray;
        imgView_North.animationDuration = 1.0;
        var northImgRect = CGRect(  x: floatingCanvas.frame.size.width/2 - arrow0.size.width/2,
                                    y: 30.0,
                                width: arrow0.size.width,
                               height: arrow0.size.height);
        imgView_North?.frame = northImgRect;
        floatingCanvas.addSubview(imgView_North);
        imgView_North.startAnimating();
        
        lblDistance_North = UILabel();
        lblDistance_North.textAlignment = NSTextAlignment.Center;
        lblDistance_North.textColor = UIColor.blackColor();
        lblDistance_North.font = UIFont(name:"Helvetica", size: 10.0);
        lblDistance_North.hidden = true;
        floatingCanvas.addSubview(lblDistance_North);
        
        imgView_East = UIImageView();
        imgView_East.animationImages = arrowArray;
        imgView_East.animationDuration = 1.0;
        var eastImgRect = CGRect(   x: floatingCanvas.frame.size.width - 30 - arrow0.size.height,
                                    y: floatingCanvas.frame.size.height/2 - arrow0.size.height/2,
                                    width: arrow0.size.width,
                                    height: arrow0.size.height);
        imgView_East?.frame = eastImgRect;
        imgView_East?.hidden = true;
        floatingCanvas.addSubview(imgView_East);
        imgView_East.startAnimating();
        // rotate the arrow image by 90˚
        imgView_East.transform = CGAffineTransformMakeRotation(π/2);

        lblDistance_East = UILabel();
        lblDistance_East.textAlignment = NSTextAlignment.Center;
        lblDistance_East.textColor = UIColor.blackColor();
        lblDistance_East.font = UIFont(name:"Helvetica", size: 10.0);
        lblDistance_East.hidden = true;
        floatingCanvas.addSubview(lblDistance_East);

        
        imgView_South = UIImageView();
        imgView_South.animationImages = arrowArray;
        imgView_South.animationDuration = 1.0;
        var southImgRect = CGRect(  x: floatingCanvas.frame.size.width/2 - arrow0.size.width/2,
                                    y: floatingCanvas.frame.size.height - 30 - arrow0.size.height,
                                    width: arrow0.size.width,
                                    height: arrow0.size.height);
        imgView_South?.frame = southImgRect;
        imgView_South?.hidden = true;
        floatingCanvas.addSubview(imgView_South);
        imgView_South.startAnimating();
        imgView_South.transform = CGAffineTransformMakeRotation(π);
        
        lblDistance_South = UILabel();
        lblDistance_South.textAlignment = NSTextAlignment.Center;
        lblDistance_South.textColor = UIColor.blackColor();
        lblDistance_South.font = UIFont(name:"Helvetica", size: 10.0);
        lblDistance_South.hidden = true;
        floatingCanvas.addSubview(lblDistance_South);

        imgView_West = UIImageView();
        imgView_West.animationImages = arrowArray;
        imgView_West.animationDuration = 1.0;
        var westImgRect = CGRect(   x: 30,
                                    y: floatingCanvas.frame.size.height/2 - arrow0.size.height/2,
                                    width: arrow0.size.width,
                                    height: arrow0.size.height);
        imgView_West?.frame = westImgRect;
        imgView_West?.hidden = true;
        floatingCanvas.addSubview(imgView_West);
        imgView_West.startAnimating();
        imgView_West.transform = CGAffineTransformMakeRotation(-π/2);
        
        lblDistance_West = UILabel();
        lblDistance_West.textAlignment = NSTextAlignment.Center;
        lblDistance_West.textColor = UIColor.blackColor();
        lblDistance_West.font = UIFont(name:"Helvetica", size: 10.0);
        lblDistance_West.hidden = true;
        floatingCanvas.addSubview(lblDistance_West);

        
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

        // kick off scheduled timer to read rangefinder distance and display it on a label
        timer = NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: "displayDistance", userInfo: nil, repeats: true);

        // set initial heading variable
        /*
        let setInitialHeadingTimer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "setInitialHeading", userInfo: nil, repeats: false);
        */
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }

    
// MARK: - View Methods

    
    // saves distance reading and prepares the view to capture the next distance measurement
    func capture(sender: UIButton!) {
        
        // update title label
        title.text = "Distance to wall is " + self.cmToFeetInches(self.distance!) + ".";
        distanceLabel.hidden = true;
        captureButton.hidden = true;
        var checkboxRect: CGRect;
        var lblDistanceRect: CGRect;
        
        // save distance
        switch currentDirection {
        
        case .NORTH:
            distanceToNorthWall = distance!;
            
            // This is the first measurement; set the initial CLLocationManager heading
            setInitialHeading();
            
            checkboxRect = CGRect(  x: imgView_North.frame.origin.x + imgView_North.frame.size.width/2 - checkmark.size.width/2,
                y: imgView_North.frame.origin.y,
                width: checkmark.size.width,
                height: checkmark.size.height);
            imgView_North.stopAnimating();
            imgView_North.image = checkmark;
            imgView_North.frame = checkboxRect;
            
            lblDistanceRect = CGRect(  x: imgView_North.center.x - 25.0,
                y: imgView_North.frame.origin.y - 16.0,
                width: 50.0,
                height: 12.0);
            lblDistance_North.frame = lblDistanceRect;
            lblDistance_North.text = cmToFeetInches(distanceToNorthWall);
            lblDistance_North.hidden = false;
        case .SOUTH:
            distanceToSouthWall = distance!;
            
            checkboxRect = CGRect(  x: floatingCanvas.frame.size.width/2 - checkmark.size.width/2,
                                    y: floatingCanvas.frame.size.height - 30 - checkmark.size.height,
                                width: checkmark.size.width,
                               height: checkmark.size.height);
            
            imgView_South.stopAnimating();
            imgView_South.image = checkmark;
            imgView_South.frame = checkboxRect;
            imgView_South.transform = CGAffineTransformMakeRotation(π);
            
            lblDistanceRect = CGRect(  x: imgView_South.center.x - 25.0,
                y: imgView_South.frame.origin.y - 16.0,
                width: 50.0,
                height: 12.0);
            lblDistance_South.frame = lblDistanceRect;
            lblDistance_South.text = cmToFeetInches(distanceToSouthWall);
            lblDistance_South.hidden = false;
        case .EAST:
            distanceToEastWall = distance!;
            
            checkboxRect = CGRect(  x: floatingCanvas.frame.size.width - 30 - checkmark.size.height,
                                    y: floatingCanvas.frame.size.height/2 - checkmark.size.height/2,
                                width: checkmark.size.width,
                               height: checkmark.size.height);

            imgView_East.stopAnimating();
            imgView_East.image = checkmark;
            imgView_East.frame = checkboxRect;
            
            lblDistanceRect = CGRect(  x: imgView_East.center.x - 25.0,
                y: imgView_East.frame.origin.y - 16.0,
                width: 50.0,
                height: 12.0);
            lblDistance_East.frame = lblDistanceRect;
            lblDistance_East.text = cmToFeetInches(distanceToEastWall);
            lblDistance_East.hidden = false;
        case .WEST:
            distanceToWestWall = distance!;
            
            checkboxRect = CGRect(  x: 30,
                                    y: floatingCanvas.frame.size.height/2 - checkmark.size.height/2,
                                width: checkmark.size.width,
                               height: checkmark.size.height);
            
            imgView_West.stopAnimating();
            imgView_West.image = checkmark;
            imgView_West.frame = checkboxRect;
            
            lblDistanceRect = CGRect(  x: imgView_West.center.x - 25.0,
                y: imgView_West.frame.origin.y - 16.0,
                width: 50.0,
                height: 12.0);
            lblDistance_West.frame = lblDistanceRect;
            lblDistance_West.text = cmToFeetInches(distanceToWestWall);
            lblDistance_West.hidden = false;

            // update help text
            title.text = "Congratulations! You've measured this room.";
        }
        
        // start capturing user's rotation
        if (currentDirection != .WEST) {
            let rotateTimer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "startRotating", userInfo: nil, repeats: false);
        }
    }
    
    /*
    override func drawRect(rect: CGRect) {
    
    }
    */
   
    // display distance in the label
    func displayDistance() {
        self.distance = Int(self.rangefinder.distance);
        self.distanceLabel.text = self.cmToFeetInches(self.distance!);
    }
    
    func setInitialHeading() {
        initialHeading = -locationManager!.heading.trueHeading * M_PI / 180.0;
        
        if (initialHeading > 2 * M_PI) {
            initialHeading -= 2 * M_PI;
        }
        println(String(format: "initial heading: %.1f", initialHeading));
    }
    
    func startRotating() {
        title.text = "Turn towards the next wall";
        isRotating = true;
    }
    
    // stops rotation and snaps the floatingCanvas to 90˚
    func snapTo90Degrees(snapRadians: Double) {
        floatingCanvas.transform = CGAffineTransformMakeRotation(CGFloat(snapRadians));
        
        isRotating = false;
        displayNextDirection();
    }
    
    // draws the appropriate view for capturing the next wall measurement
    func displayNextDirection() {
        // update help text
        title.text = HELP_TEXT_POINT;
        distanceLabel.hidden = false;
        captureButton.hidden = false;
        
        switch currentDirection {
        
        case .NORTH:
            currentDirection = .EAST;
            
            // after rotating make the checkbox face the right direction again
            distanceLabel.transform = CGAffineTransformMakeRotation(π/2);
            imgView_North.transform = CGAffineTransformMakeRotation(π/2);
            imgView_East.hidden = false;

        case .EAST:
            currentDirection = .SOUTH
            
            distanceLabel.transform = CGAffineTransformMakeRotation(π);
            imgView_North.transform = CGAffineTransformMakeRotation(π);
            imgView_East.transform = CGAffineTransformMakeRotation(π);
            imgView_South.hidden = false;

        case .SOUTH:
            currentDirection = .WEST

            distanceLabel.transform = CGAffineTransformMakeRotation(3*π/2);
            imgView_North.transform = CGAffineTransformMakeRotation(3*π/2);
            imgView_East.transform = CGAffineTransformMakeRotation(3*π/2);
            imgView_South.transform = CGAffineTransformMakeRotation(3*π/2);
            imgView_West.hidden = false;
            
        case .WEST:
            currentDirection = .NORTH
            
            //imgView_West.transform = CGAffineTransformMakeRotation(π/2);
        }
    }
    
// MARK: - Utility Methods
    
    // Utility routine to convert cm to feet and inches
    private func cmToFeetInches(cm: Int) -> String {
        var inches: Float = Float(cm) / 2.54;
        var feet: Int = Int(inches)  / 12;
        
        inches = inches - (12 * Float(feet));
        return String(format: "%d' %.1f\"", feet, inches);
    }

}

extension CreateRoomView: CLLocationManagerDelegate {

// MARK: - Location Manager Methods
    func locationManager(manager: CLLocationManager!, didUpdateHeading newHeading: CLHeading!) {
        
        // rotate display
        if (isRotating) {
            // Convert Degree to Radian and move the needle
            var oldRad =  -manager.heading.trueHeading * M_PI / 180.0;
            var newRad =  -newHeading.trueHeading * M_PI / 180.0;
            //println(String(format:"oldRad: %.1f, newRad: %.1f", oldRad, newRad));
            
            var theAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation");
            theAnimation.fromValue = oldRad - initialHeading;
            theAnimation.toValue = newRad - initialHeading;
            theAnimation.duration = 0.5;
            floatingCanvas.layer.addAnimation(theAnimation, forKey: "animateMyRotation");
            floatingCanvas.transform = CGAffineTransformMakeRotation(CGFloat(newRad - initialHeading));
            
            
            switch currentDirection {
            case .NORTH:
                // stop rotating when newRad is within 0.1 radian of 90 degrees (π/2) from the initial direction
                if (abs(newRad) > abs(initialHeading) + M_PI_4
                    && abs(newRad) - abs(initialHeading) - M_PI_2 < 0.1
                    && abs(newRad) - abs(initialHeading) - M_PI_2 > -0.1) {
                    
                        println("snap after north");
                        snapTo90Degrees(-M_PI_2);
                }
            case .EAST:
                if (abs(newRad) > abs(initialHeading) + 3.0 * M_PI_4
                    && abs(newRad) - abs(initialHeading) - M_PI < 0.1
                    && abs(newRad) - abs(initialHeading) - M_PI > -0.1) {
                    
                        println("snap after east");
                        snapTo90Degrees(-M_PI);
                }
            case .SOUTH:
                if (abs(newRad) > abs(initialHeading) + 5.0 * M_PI_4
                    && abs(newRad) - abs(initialHeading) - (3.0 * M_PI_2) < 0.1
                    && abs(newRad) - abs(initialHeading) - (3.0 * M_PI_2) > 0.0) {
                        
                        println("snap after south");
                        snapTo90Degrees(-3 * M_PI_2);
                }
            case .WEST:
                println("west");
            }
        }
        
        self.currentHeading = newHeading;
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        println("didUpdateLocations");
    }
    
    func locationManagerShouldDisplayHeadingCalibration(manager: CLLocationManager!) -> Bool {
        if (self.currentHeading == nil) {
            return true;
        }
        else {
            return false;
        }
    }
    
}


