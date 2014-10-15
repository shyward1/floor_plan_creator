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
    
    let HELP_TEXT_POINT: String = String("Point to the wall and click measure");
    
    let house = UIImage(named: "house");
    let rotate = UIImage(named: "rotate");
    
    var captureButton: UIButton = UIButton();
    var title: UILabel = UILabel();
    var distanceLabel: UILabel = UILabel();
    var numRoomsLabel: UILabel = UILabel();
    var houseImgView: UIImageView!
    var rotateImgView: UIImageView!
    var txtRoomName: UITextField!
    var imgView_North: ArrowImageView!
    var imgView_South: ArrowImageView!
    var imgView_East: ArrowImageView!
    var imgView_West: ArrowImageView!
    
    // sub view that the distance label and arrows are on
    var floatingCanvas: UIView = UIView();

    var rangefinder: Rangefinder!
    var parent: MeasureRoomViewController!
    
    var timer: NSTimer!
    
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
        
        // title help text label
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
        
        // rangefinder distance label inside floating canvas
        distanceLabel.frame = CGRect(x: 0.0, y: floatingCanvas.frame.size.height/2-25.0, width: floatingCanvas.frame.size.width, height: 50.0);
        distanceLabel.textAlignment = NSTextAlignment.Center;
        distanceLabel.textColor = UIColor.blackColor();
        distanceLabel.font = UIFont(name:"Helvetica", size: 20.0);
        distanceLabel.text = "";
        floatingCanvas.addSubview(distanceLabel);
        
        // big rotation arrow centered on iPad landscape mode
        rotateImgView = UIImageView();
        rotateImgView.image = rotate;
        rotateImgView.frame = CGRect(x: self.frame.size.width*2/3-rotate.size.width/2, y: frame.size.height/2-rotate.size.height,
            width: rotate.size.width,
            height: rotate.size.height);
        rotateImgView.alpha = 0.0;
        self.addSubview(rotateImgView);
        
        // house image and number of rooms label
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

        // animated arrow images placed on the floating canvas with 30 pixel padding
        imgView_North = ArrowImageView(center: CGPoint(x: floatingCanvas.frame.size.width / 2.0, y: 80.0));
        imgView_South = ArrowImageView(center: CGPoint(x: floatingCanvas.frame.size.width / 2.0, y: floatingCanvas.frame.size.height - 80.0));
        imgView_East = ArrowImageView(center: CGPoint(x: floatingCanvas.frame.size.width - 80.0, y: floatingCanvas.frame.size.height / 2.0));
        imgView_West = ArrowImageView(center: CGPoint(x: 80.0, y: floatingCanvas.frame.size.height / 2.0));
        floatingCanvas.addSubview(imgView_North as UIImageView);
        floatingCanvas.addSubview(imgView_South as UIImageView);
        floatingCanvas.addSubview(imgView_East as UIImageView);
        floatingCanvas.addSubview(imgView_West as UIImageView);
        
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
    
    // called by parent when preparing to measure a new room
    func newRoom() {
        distanceToNorthWall = 0;
        distanceToSouthWall = 0;
        distanceToEastWall  = 0;
        distanceToWestWall  = 0;
        
        isFinishedMeasuring = false;
        locationManager!.startUpdatingHeading();
        
        // position arrow images
        imgView_North.direction = ArrowDirection.UP;
        imgView_North.setArrow(duration: 0.0);
        imgView_North.hidden = false;
        imgView_South.direction = ArrowDirection.DOWN;
        imgView_South.hidden = true;
        imgView_South.setArrow(duration: 0.0);
        imgView_East.direction = ArrowDirection.RIGHT;
        imgView_East.hidden = true;
        imgView_East.setArrow(duration: 0.0);
        imgView_West.direction = ArrowDirection.LEFT;
        imgView_West.hidden = true;
        imgView_West.setArrow(duration: 0.0);
        
        // make sure we are pointing in the right direction
        switch currentDirection {
        case .NORTH:
            println("already pointing in the correct direction");
        case .SOUTH:
            floatingCanvas.transform = CGAffineTransformMakeRotation(CGFloat(π));
        case .EAST:
            floatingCanvas.transform = CGAffineTransformMakeRotation(CGFloat(-π/2));
        case .WEST:
            floatingCanvas.transform = CGAffineTransformMakeRotation(CGFloat(π/2));
        }
        
        currentDirection = .NORTH;
        
        // kick off scheduled timer to read rangefinder distance and display it on a label
        timer = NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: "displayDistance", userInfo: nil, repeats: true);
        
        var captureButtonAnimationTimer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: "captureButtonAnimation", userInfo: nil, repeats: true);
    }
    
    // creates a room object and saves it
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
        title.text = "Distance to wall is " + Util.cmToFeetInches(centimeters: self.distance!);
        
        // fade out
        UIView.animateWithDuration(1.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.distanceLabel.alpha = 0.0;
            self.captureButton.alpha = 0.0;
            }) { (Bool) -> Void in
                self.distanceLabel.hidden = true;
                self.captureButton.hidden = true;
            }

        switch currentDirection {
        
        case .NORTH:
            distanceToNorthWall = distance!;
            
            // This is the first measurement; remember the initial CLLocationManager heading
            setInitialHeading();
            
            // change the arrow to a checkmark image
            imgView_North.setChecked();
            
        case .SOUTH:
            distanceToSouthWall = distance!;
            
            //imgView_South.direction = ArrowDirection.UP;
            imgView_South.setChecked();

        case .EAST:
            distanceToEastWall = distance!;
            
            imgView_East.setChecked();
            
        case .WEST:
            isFinishedMeasuring = true;
            isRotating = false;
            distanceToWestWall = distance!;
            
            var width = Util.cmToFeetInches(centimeters: distanceToEastWall + distanceToWestWall + DISTANCE_BODY_OFFSET);
            var height = Util.cmToFeetInches(centimeters: distanceToNorthWall + distanceToSouthWall + DISTANCE_BODY_OFFSET);
            
            // fade title out with individual measurement distance text and fade in room dimensions text
            UIView.animateWithDuration(0.5, delay: 1.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                self.title.alpha = 0.0;
                }) { (Bool) -> Void in
                    self.title.text = String(format:"%@ x %@", width, height);
                    UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
                        self.title.alpha = 1.0;
                        }) { (Bool) -> Void in
                    }
            }
            
            imgView_West.setChecked();
            
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
            self.distanceLabel.text = Util.cmToFeetInches(centimeters: self.distance!);
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
            imgView_North.direction = ArrowDirection.RIGHT;
            //imgView_North.transform = CGAffineTransformMakeRotation(π/2);
            imgView_East.hidden = false;

        case .EAST:
            currentDirection = .SOUTH
            
            distanceLabel.transform = CGAffineTransformMakeRotation(π);
            imgView_North.direction = ArrowDirection.DOWN;
            imgView_East.direction = ArrowDirection.DOWN;
            //imgView_North.transform = CGAffineTransformMakeRotation(π);
            //imgView_East.transform = CGAffineTransformMakeRotation(π);
            imgView_South.hidden = false;

        case .SOUTH:
            currentDirection = .WEST

            distanceLabel.transform = CGAffineTransformMakeRotation(3*π/2);
            imgView_North.direction = ArrowDirection.LEFT;
            imgView_East.direction = ArrowDirection.LEFT;
            imgView_South.direction = ArrowDirection.LEFT;
            //imgView_North.transform = CGAffineTransformMakeRotation(3*π/2);
            //imgView_East.transform = CGAffineTransformMakeRotation(3*π/2);
            //imgView_South.transform = CGAffineTransformMakeRotation(3*π/2);
            imgView_West.hidden = false;
        case .WEST:
            currentDirection = .NORTH;
        }
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


// MARK: - Location Manager Methods

extension CreateRoomView: CLLocationManagerDelegate {

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

                        snapTo90Degrees(-M_PI_2);
                }
            case .EAST:
                if (abs(abs(newRad) - abs(initialHeading)) - M_PI < 0.1
                    && abs(abs(newRad) - abs(initialHeading)) - M_PI > -0.1) {

                        snapTo90Degrees(-M_PI);
                }
            case .SOUTH:
                if ( abs(abs(newRad) - abs(initialHeading)) - (3.0 * M_PI_2) < 0.1
                    && abs(abs(newRad) - abs(initialHeading)) - (3.0 * M_PI_2) > -0.1) {

                        snapTo90Degrees(-3 * M_PI_2);
                }
                else if (abs(abs(newRad) - abs(initialHeading)) - M_PI_2 < 0.1
                    && abs(abs(newRad) - abs(initialHeading)) - M_PI_2 > -0.1) {

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


