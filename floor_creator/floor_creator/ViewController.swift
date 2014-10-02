//
//  ViewController.swift
//  floor_creator
//
//  Created by Shy Ward on 10/1/14.
//  Copyright (c) 2014 Shy Ward. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
   
    @IBOutlet weak var degreeField: UILabel!

    @IBOutlet weak var levelDrawingView: UIView!
    @IBOutlet weak var nextButton: UIButton!
    
    let motionManager: CMMotionManager = CMMotionManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        motionManager.deviceMotionUpdateInterval = 0.01
        motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.currentQueue(),
            withHandler: motionUpdated)
        
        println(motionManager.deviceMotionActive) // print false

    }

    /*
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        var touch: AnyObject? = event.allTouches()?.anyObject()
        if(touch?.view == imageOutlet)
        {
            let location = touch?.locationInView(self.view)
            imageOutlet.center = location!;
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        var touch: AnyObject? = event.allTouches()?.anyObject()
        if(touch?.view == imageOutlet)
        {
            let location = touch?.locationInView(self.view)
            imageOutlet.center = location!;
        }
    }
    */
    override func viewWillDisappear(animated: Bool) {
        motionManager.stopDeviceMotionUpdates()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func motionUpdated(motion: CMDeviceMotion!, error: NSError!) {
        if (error != nil) {
            NSLog("\(error)")
        }
        
        let grav : CMAcceleration = motion.gravity;
        
        let x = CGFloat(grav.x);
        let y = CGFloat(grav.y);
        let z = CGFloat(grav.z);
        
        var v = CGVectorMake(x, y);

        let test = CGFloat(M_PI);
        //println("z:\(z)")
        //convert to degrees
        var z_degree = z * (180.0 / test);
        println("z degree: \(z_degree)")
        
        let string = "\(z_degree)"
        println(string)
        degreeField.text = string
        //are we level go green otherwise red
        if(z_degree >= -11.0 && z_degree <= 11.0)
        {
            levelDrawingView.backgroundColor = UIColor.greenColor()
        }
        else
        {
            levelDrawingView.backgroundColor = UIColor.redColor()
        }
    }

}

