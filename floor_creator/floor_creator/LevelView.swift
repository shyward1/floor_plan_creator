//
//  LevelView.swift
//  floor_creator
//
//  Created by Shy Ward on 10/2/14.
//  Copyright (c) 2014 Shy Ward. All rights reserved.
//

import UIKit
import CoreMotion

class LevelView: UIView {

    let π = CGFloat(M_PI);
    let motionManager: CMMotionManager = CMMotionManager();
    var levelDrawingView: UIView = UIView();
    var lblLevel: UILabel = UILabel();
    
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        
        motionManager.deviceMotionUpdateInterval = 0.05;
        motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.currentQueue(),
            withHandler: motionUpdated);
        
        self.backgroundColor = UIColor.whiteColor();

        // initialize levelDrawingView
        levelDrawingView.frame = CGRect(x: self.frame.size.width/2-80.0, y: self.frame.size.height/2-40.0-66.0, width: 80.0, height: 160.0);
        levelDrawingView.layer.backgroundColor = UIColor.whiteColor().CGColor;
        levelDrawingView.layer.borderWidth = 2.0;
        levelDrawingView.layer.borderColor = UIColor.blackColor().CGColor;
        self.addSubview(levelDrawingView);

        lblLevel.frame = CGRect(x: self.frame.size.width/2-80.0, y: self.frame.size.height/2-130.0, width: 80.0, height: 16.0);
        lblLevel.textAlignment = NSTextAlignment.Center;
        lblLevel.textColor = UIColor.darkGrayColor();
        lblLevel.text = "Level";
        self.addSubview(lblLevel);
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    func cleanUp() {
        motionManager.stopDeviceMotionUpdates();
    }
   
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Drawing code
    }
    */

    
    // MARK: - Core Motion Methods
    
    func motionUpdated(motion: CMDeviceMotion!, error: NSError!) {
        if (error != nil) {
            NSLog("\(error)")
        }
        
        let grav : CMAcceleration = motion.gravity;
        
        let x = CGFloat(grav.x);
        let y = CGFloat(grav.y);
        let z = CGFloat(grav.z);
        
        var v = CGVectorMake(x, y);
        
        //convert to degrees
        var z_degree = z * (180.0 / π);
        println("z degree: \(z_degree)")

        //are we level go green otherwise red
        if(z_degree >= -11.0 && z_degree <= 11.0) {
            levelDrawingView.backgroundColor = UIColor.greenColor();
        }
        else {
            levelDrawingView.backgroundColor = UIColor.redColor();
        }
    }

}
