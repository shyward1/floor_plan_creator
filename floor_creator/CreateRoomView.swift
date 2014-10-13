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


class CreateRoomView: UIView, CLLocationManagerDelegate, UITextFieldDelegate {
    
    // used for keeping track of the direction the user is facing
    var locationManager: CLLocationManager?
    var currentHeading: CLHeading?
    
    // stores the initial heading in radians, after CLLocationManager has initialized
    var initialHeading = 0.0;
    
    let π = CGFloat(M_PI);
    let colorThemeBlue: UIColor = UIColor(red: 26/255.0, green: 126/255.0, blue: 225/255.0, alpha: 1.0);
    
    // the amount of additional distance to add to a room width or height that wasn't measured due to the
    // person holding the iPad away from their body.  2' is ~61cm.
    let DISTANCE_BODY_OFFSET = 61;
    
    var captureButton: UIButton = UIButton();
    var title: UILabel = UILabel();
    var distanceLabel: UILabel = UILabel();
    var numRoomsLabel: UILabel = UILabel();
    
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
    let house = UIImage(named: "house");
    let rotate = UIImage(named: "rotate");
    
    let HELP_TEXT_POINT: String = String("Point to the wall and click measure");
    
    var imgView_North: UIImageView!
    var imgView_South: UIImageView!
    var imgView_East: UIImageView!
    var imgView_West: UIImageView!
    var houseImgView: UIImageView!
    var rotateImgView: UIImageView!
    
    var txtRoomName: UITextField!

    var rangefinder: Rangefinder!
    var parent: MeasureRoomViewController!
    
    var timer: NSTimer!
    
    // keeps track of which wall is being measured
    enum Direction {
        case NORTH
        case EAST
        case SOUTH
        case WEST
    }
    
    var isRotating: Bool = false;
    var hasStartedRotating: Bool = false;
    
    // stores the distance value in cm
    var distance: Int! = 0;
    
    var currentDirection: Direction = .NORTH;
    
    // represents a measurement from somewhere inside the room to the wall on the north side of the room, in cm.
    var distanceToNorthWall = 0;
    
    // represents a measurement from somewhere inside the room to the south facing wall, in cm.
    var distanceToSouthWall = 0;
    
    // represents a measurement from somewhere inside the room to the east facing wall, in cm.
    var distanceToEastWall = 0;
    
    // represents a measurement from somewhere inside the room to the west facing wall, in cm.
    var distanceToWestWall = 0;
    
    // what this room is called
    var roomName: String = "Unnamed Room";
    
    var isFinishedMeasuring: Bool = false;
    
    
    // constructor
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        // instantiate Rangefinder and start video capture
        rangefinder = Rangefinder();
        
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
        
        // set border and background color
        self.backgroundColor = UIColor.whiteColor();
        
        title.frame = CGRect(x: self.frame.size.width*2/3-150.0, y: 70.0, width: 300.0, height: 20.0);
        title.textAlignment = NSTextAlignment.Center;
        title.textColor = colorThemeBlue;
        self.addSubview(title);
        
        // floating canvas
        floatingCanvas.frame = CGRect(x: self.frame.size.width*2/3-150, y: frame.size.height/2-150, width: 300.0, height: 300.0);
        floatingCanvas.backgroundColor = UIColor.whiteColor();
        floatingCanvas.layer.borderWidth = 2.0;
        floatingCanvas.layer.borderColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), [0.1, 0.1, 0.1, 0.1]);
        self.addSubview(floatingCanvas);
        
        distanceLabel.frame = CGRect(x: 0.0, y: floatingCanvas.frame.size.height/2-25.0, width: floatingCanvas.frame.size.width, height: 50.0);
        distanceLabel.textAlignment = NSTextAlignment.Center;
        distanceLabel.textColor = UIColor.blackColor();
        distanceLabel.font = UIFont(name:"Helvetica", size: 20.0);
        distanceLabel.text = "";
        floatingCanvas.addSubview(distanceLabel);
        
        // draw the arrow images and distance labels
        let arrowArray: [UIImage] = [arrow0, arrow10, arrow20, arrow30, arrow40, arrow50, arrow60, arrow70, arrow80, arrow90, arrow100];
        
        rotateImgView = UIImageView();
        rotateImgView.image = rotate;
        
        // center image in iPad landscape mode
        rotateImgView.frame = CGRect(x: self.frame.size.width*2/3-rotate.size.width/2, y: frame.size.height/2-rotate.size.height,
            width: rotate.size.width,
            height: rotate.size.height);
        // set initial alpha to 0 (translucent)
        rotateImgView.alpha = 0.0;
        self.addSubview(rotateImgView);
        
        houseImgView = UIImageView();
        houseImgView.image = house;
        houseImgView.frame = CGRect(x: 30.0, y: 80.0, width: house.size.width, height: house.size.width);
        self.addSubview(houseImgView);
        
        numRoomsLabel.frame = CGRect(x: 30.0+house.size.width, y: houseImgView.frame.origin.y-5.0, width: 20.0, height: 20.0);
        numRoomsLabel.textAlignment = NSTextAlignment.Center;
        numRoomsLabel.textColor = colorThemeBlue;
        numRoomsLabel.font = UIFont(name:"Helvetica", size: 20.0);
        numRoomsLabel.text = String(FloorPlanDAO.sharedInstance.countRooms());
        self.addSubview(numRoomsLabel);

        imgView_North = UIImageView();
        imgView_North.animationImages = arrowArray;
        imgView_North.animationDuration = 1.0;
        imgView_North?.frame = CGRect(  x: floatingCanvas.frame.size.width/2 - arrow0.size.width/2, y: 30.0, width: arrow0.size.width, height: arrow0.size.height);
        floatingCanvas.addSubview(imgView_North);
        imgView_North.startAnimating();
        
        imgView_East = UIImageView();
        imgView_East.animationImages = arrowArray;
        imgView_East.animationDuration = 1.0;
        imgView_East?.frame = CGRect(   x: floatingCanvas.frame.size.width - 30 - arrow0.size.height, y: floatingCanvas.frame.size.height/2 - arrow0.size.height/2, width: arrow0.size.width, height: arrow0.size.height);
        imgView_East?.hidden = true;
        floatingCanvas.addSubview(imgView_East);
        imgView_East.startAnimating();
        // rotate the arrow image by 90˚
        imgView_East.transform = CGAffineTransformMakeRotation(π/2);
        
        imgView_South = UIImageView();
        imgView_South.animationImages = arrowArray;
        imgView_South.animationDuration = 1.0;
        imgView_South?.frame = CGRect(  x: floatingCanvas.frame.size.width/2 - arrow0.size.width/2,
            y: floatingCanvas.frame.size.height - 30 - arrow0.size.height, width: arrow0.size.width, height: arrow0.size.height)
        imgView_South?.hidden = true;
        floatingCanvas.addSubview(imgView_South);
        imgView_South.startAnimating();
        imgView_South.transform = CGAffineTransformMakeRotation(π);
        
        imgView_West = UIImageView();
        imgView_West.animationImages = arrowArray;
        imgView_West.animationDuration = 1.0;
        imgView_West?.frame = CGRect(   x: 30,
            y: floatingCanvas.frame.size.height/2 - arrow0.size.height/2, width: arrow0.size.width, height: arrow0.size.height);
        imgView_West?.hidden = true;
        floatingCanvas.addSubview(imgView_West);
        imgView_West.startAnimating();
        imgView_West.transform = CGAffineTransformMakeRotation(-π/2);
        
        // draw the capture circle button
        captureButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton;
        captureButton.setTitle("measure", forState: .Normal);
        captureButton.setTitleColor(colorThemeBlue, forState: .Normal);
        captureButton.titleLabel?.font = UIFont(name:"Helvetica", size: 16.0)
        captureButton.addTarget(self, action: "capture:", forControlEvents: .TouchUpInside);
        captureButton.frame = CGRect(x: 30, y: self.frame.size.height/2-66.0, width: 80.0, height: 80.0);
        captureButton.clipsToBounds = true;
        captureButton.layer.cornerRadius = 40.0;
        captureButton.layer.borderColor = colorThemeBlue.CGColor;
        captureButton.layer.borderWidth = 3.0;
        self.addSubview(captureButton);

        // textbox for inputting the room name
        /*
        var txtfieldRect = CGRect(x: self.frame.size.width/2, y: 40, width: 300, height: 25.0);
        txtRoomName = UITextField(frame: txtfieldRect);
        txtRoomName.text = roomName;
        txtRoomName.delegate = self;
        txtRoomName.borderStyle = UITextBorderStyle.None;
        //self.addSubview(txtRoomName);
        */
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }

    func cleanUp() {
        isRotating = false;
        isFinishedMeasuring = true;
        
        locationManager?.stopUpdatingHeading();
    }
    
    // called by parent
    func newRoom() {
        distanceToNorthWall = 0;
        distanceToSouthWall = 0;
        distanceToEastWall  = 0;
        distanceToWestWall  = 0;
        
        currentDirection = .NORTH;
        
        isFinishedMeasuring = false;
        locationManager!.startUpdatingHeading();
        
        // kick off scheduled timer to read rangefinder distance and display it on a label
        timer = NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: "displayDistance", userInfo: nil, repeats: true);
        
        var captureButtonAnimationTimer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "captureButtonAnimation", userInfo: nil, repeats: true);
    }
    
    // creates a room object and saves it with the parent
    func saveRoom() {
        var width = CGFloat(distanceToEastWall + distanceToWestWall + DISTANCE_BODY_OFFSET);
        var depth = CGFloat(distanceToNorthWall + distanceToSouthWall + DISTANCE_BODY_OFFSET);
        
        var room: Room = Room(width: width, depth: depth, name: roomName);
        
        FloorPlanDAO.sharedInstance.addRoom(room, level: 1);
        numRoomsLabel.text = String(FloorPlanDAO.sharedInstance.countRooms());
    }
    
// MARK: - View Methods
    
    // grows and shrinks the capture button to make it more obvious to the user
    func captureButtonAnimation() {
        if (captureButton.frame.size.width == 80) {
            captureButton.transform = CGAffineTransformMakeScale(CGFloat(1.1), CGFloat(1.1));
            let shrink = NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: "captureButtonAnimation", userInfo: nil, repeats: false);
        }
        else {
            captureButton.transform = CGAffineTransformMakeScale(CGFloat(1.0), CGFloat(1.0));
        }
    }
    
    // saves distance reading and prepares the view to capture the next distance measurement
    func capture(sender: UIButton!) {
        
        // update title label
        title.text = "Distance to wall is " + self.cmToFeetInches(self.distance!);
        
        // fade out
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.distanceLabel.alpha = 0.0;
            self.captureButton.alpha = 0.0;
            }) { (Bool) -> Void in
                self.distanceLabel.hidden = true;
                self.captureButton.hidden = true;
            }
        
        var checkboxRect: CGRect;
        
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
            imgView_North.alpha = 0.0;
            imgView_North.image = checkmark;
            imgView_North.frame = checkboxRect;
            
            // fade checkmark image in
            UIView.animateWithDuration(2.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                self.imgView_North.alpha = 1.0;
                }) { (Bool) -> Void in
            }
  
        case .SOUTH:
            distanceToSouthWall = distance!;
            
            checkboxRect = CGRect(  x: floatingCanvas.frame.size.width/2 - checkmark.size.width/2,
                                    y: floatingCanvas.frame.size.height - 30 - checkmark.size.height,
                                width: checkmark.size.width,
                               height: checkmark.size.height);
            
            imgView_South.stopAnimating();
            imgView_South.alpha = 0.0;
            imgView_South.image = checkmark;
            imgView_South.frame = checkboxRect;
            imgView_South.transform = CGAffineTransformMakeRotation(π);
            
            // fade checkmark image in
            UIView.animateWithDuration(2.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                self.imgView_South.alpha = 1.0;
                }) { (Bool) -> Void in
            }

        case .EAST:
            distanceToEastWall = distance!;
            
            checkboxRect = CGRect(  x: floatingCanvas.frame.size.width - 30 - checkmark.size.height,
                                    y: floatingCanvas.frame.size.height/2 - checkmark.size.height/2,
                                width: checkmark.size.width,
                               height: checkmark.size.height);

            imgView_East.stopAnimating();
            imgView_East.alpha = 0.0;
            imgView_East.image = checkmark;
            imgView_East.frame = checkboxRect;
            
            // fade checkmark image in
            UIView.animateWithDuration(2.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                self.imgView_East.alpha = 1.0;
                }) { (Bool) -> Void in
            }
 
        case .WEST:
            isFinishedMeasuring = true;
            isRotating = false;
            distanceToWestWall = distance!;
            
            checkboxRect = CGRect(  x: 30,
                                    y: floatingCanvas.frame.size.height/2 - checkmark.size.height/2,
                                width: checkmark.size.width,
                               height: checkmark.size.height);
            
            imgView_West.stopAnimating();
            imgView_West.alpha = 0.0;
            imgView_West.image = checkmark;
            imgView_West.frame = checkboxRect;

            var width = cmToFeetInches(distanceToEastWall + distanceToWestWall + DISTANCE_BODY_OFFSET);
            var height = cmToFeetInches(distanceToNorthWall + distanceToSouthWall + DISTANCE_BODY_OFFSET);
            
            // fade title out with individual measurement distance text and fade in room dimensions text
            UIView.animateWithDuration(0.5, delay: 1.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self.title.alpha = 0.0;
                }) { (Bool) -> Void in
                    self.title.text = String(format:"%@ x %@", width, height);
            }
            
            // fade checkmark image and room dimensions title in
            UIView.animateWithDuration(0.5, delay: 1.5, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                self.imgView_West.alpha = 1.0;
                self.title.alpha = 1.0;
                }) { (Bool) -> Void in
            }
            
            // add this Room object to the array of rooms for this floor and floor plan
            saveRoom();
            
            // notify parent that a room has completed measuring
            let notifyParentTimer = NSTimer.scheduledTimerWithTimeInterval(5.0, target: self, selector: "didFinishMeasuringRoom", userInfo: nil, repeats: false);
        }
        
        // start capturing user's rotation
        if (currentDirection != .WEST) {
            let rotateTimer = NSTimer.scheduledTimerWithTimeInterval(2.5, target: self, selector: "startRotating", userInfo: nil, repeats: false);
        }
    }
   
    func didFinishMeasuringRoom() {
        parent!.didFinishMeasuringRoom();
    }
    
    // display distance in the label
    func displayDistance() {
        if (!isFinishedMeasuring) {
            self.distance = Int(self.rangefinder.distance);
            self.distanceLabel.text = self.cmToFeetInches(self.distance!);
        }
    }
    
    func setInitialHeading() {
        initialHeading = -locationManager!.heading.trueHeading * M_PI / 180.0;
        
        if (initialHeading > 2 * M_PI) {
            initialHeading -= 2 * M_PI;
        }
        println(String(format: "initial heading: %.1f", initialHeading));
    }
    
    func startRotating() {
        // fade the rotate image in
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.rotateImgView.alpha = 1.0;
        }) { (Bool) -> Void in
            self.isRotating = true;
            self.title.text = "";
        }
    }
    
    // stops rotation and snaps the floatingCanvas to 90˚
    func snapTo90Degrees(snapRadians: Double) {
        // fade the rotate image out
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.rotateImgView.alpha = 0.0;
            }) { (Bool) -> Void in
        }

        floatingCanvas.transform = CGAffineTransformMakeRotation(CGFloat(snapRadians));
        isRotating = false;
        hasStartedRotating = false;
        displayNextDirection();
    }
    
    // draws the appropriate view for capturing the next wall measurement
    func displayNextDirection() {
        // update help text
        title.text = "";
        
        // fade in
        distanceLabel.hidden = false;
        captureButton.hidden = false;
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.distanceLabel.alpha = 1.0;
            self.captureButton.alpha = 1.0;
            }) { (Bool) -> Void in
        }
        
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

// MARK: - UITextField Delegate Methods
    
    func textFieldDidBeginEditing(textField: UITextField!) {
        if (textField.text == "Unnamed Room") {
            textField.text = "";
        }
    }
    
    func textFieldShouldEndEditing(textField: UITextField!) -> Bool {
        return false;
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool {
        roomName = textField.text;
        
        return true;
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
            println(String(format:"newRad: %.1f", newRad));
            
            var theAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation");
            theAnimation.fromValue = oldRad - initialHeading;
            theAnimation.toValue = newRad - initialHeading;
            theAnimation.duration = 0.5;
            floatingCanvas.layer.addAnimation(theAnimation, forKey: "animateMyRotation");
            floatingCanvas.transform = CGAffineTransformMakeRotation(CGFloat(newRad - initialHeading));
            
            // if the user has begun rotating the iPad fade the rotate image out
            if (abs(newRad) > abs(initialHeading) + 0.2 || abs(newRad) < abs(initialHeading) - 0.2) {
                hasStartedRotating = true;
            }
            
            if (hasStartedRotating) {
                // fade the rotate image out
                UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                    self.rotateImgView.alpha = 0.0;
                    }) { (Bool) -> Void in
                }
            }
            
            switch currentDirection {
            case .NORTH:
                // stop rotating when newRad is within 0.1 radian of 90 degrees (π/2) from the initial direction
                if (abs(newRad) > abs(initialHeading) + M_PI_4
                    && abs(abs(newRad) - abs(initialHeading)) - M_PI_2 < 0.1
                    && abs(abs(newRad) - abs(initialHeading)) - M_PI_2 > -0.1) {
                    
                        println("snap after north");
                        snapTo90Degrees(-M_PI_2);
                }
            case .EAST:
                if (abs(abs(newRad) - abs(initialHeading)) - M_PI < 0.1
                    && abs(abs(newRad) - abs(initialHeading)) - M_PI > -0.1) {
                    
                        println("snap after east");
                        snapTo90Degrees(-M_PI);
                }
            case .SOUTH:
                if ( abs(abs(newRad) - abs(initialHeading)) - (3.0 * M_PI_2) < 0.1
                    && abs(abs(newRad) - abs(initialHeading)) - (3.0 * M_PI_2) > -0.1) {
                    
                        println("snap after south -3pi/2");
                        snapTo90Degrees(-3 * M_PI_2);
                }
                else if (abs(abs(newRad) - abs(initialHeading)) - M_PI_2 < 0.1
                    && abs(abs(newRad) - abs(initialHeading)) - M_PI_2 > -0.1) {
                        
                        println("snap after south, -3 * pi/2");
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


