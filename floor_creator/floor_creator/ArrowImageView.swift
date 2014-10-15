//
//  ArrowImageView.swift
//  floor_creator
//
//  Created by Mark Reimer on 10/13/14.
//  Copyright (c) 2014 Shy Ward. All rights reserved.
//

import Foundation
import UIKit

// direction of the arrow on the iPad display. 
// UP points to the top of the iPad screen
// DOWN points to the bottom of the screen
// LEFT points to the front camera or iPad button when in landscape mode
// RIGHT points in the opposite direction as LEFT
public enum ArrowDirection {
    case UP
    case DOWN
    case LEFT
    case RIGHT
}

let DEFAULT_DURATION: NSTimeInterval = 1.0;
let DEFAULT_DELAY: NSTimeInterval = 0.0;

class ArrowImageView: UIImageView {
    let π = CGFloat(M_PI);
    
    let arrow0    = UIImage(named: "arrow-up-0");
    let arrow10   = UIImage(named: "arrow-up-10");
    let arrow20   = UIImage(named: "arrow-up-20");
    let arrow30   = UIImage(named: "arrow-up-30");
    let arrow40   = UIImage(named: "arrow-up-40");
    let arrow50   = UIImage(named: "arrow-up-50");
    let arrow60   = UIImage(named: "arrow-up-60");
    let arrow70   = UIImage(named: "arrow-up-70");
    let arrow80   = UIImage(named: "arrow-up-80");
    let arrow90   = UIImage(named: "arrow-up-90");
    let arrow100  = UIImage(named: "arrow-up-100");
    let checkmark = UIImage(named: "checkmark");
    
    var arrowArray: [UIImage]!
    
    // represents the direction this arrow is pointing
    var direction: ArrowDirection = .UP {
        willSet(newDirection) {             // not to be confused with the boy band
            rotate(newDirection);
        }
    }
    
    // true when arrow image is being displayed; false otherwise
    var isArrow: Bool = true;
    
    
    // public constructor
    init(center: CGPoint) {
        super.init(frame: CGRect(x: center.x-arrow0.size.width/2.0, y: center.y-arrow0.size.height/2.0, width: arrow0.size.width, height: arrow0.size.height));
        
        arrowArray = [arrow0, arrow10, arrow20, arrow30, arrow40, arrow50, arrow60, arrow70, arrow80, arrow90, arrow100];
        
        self.animationImages = arrowArray;
        self.animationDuration = DEFAULT_DURATION;
        self.startAnimating();
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    
    
    // MARK: - Display Methods
    
    func fadeOut(duration dur: NSTimeInterval = DEFAULT_DURATION, delay del: NSTimeInterval = DEFAULT_DELAY) {
        UIView.animateWithDuration(dur, delay: del, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.alpha = 0.0;
            }) { (Bool) -> Void in
        }
    }

    func fadeIn(duration dur: NSTimeInterval = DEFAULT_DURATION, delay del: NSTimeInterval = DEFAULT_DELAY) {
        UIView.animateWithDuration(dur, delay: del, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.alpha = 1.0;
            }) { (Bool) -> Void in
        }
    }

    // replaces the arrow animation with a checkmark
    func setChecked(duration dur: NSTimeInterval = DEFAULT_DURATION, delay del: NSTimeInterval = DEFAULT_DELAY) {
        if (!isArrow) {
            return;
        }
        
        fadeOut(duration: dur/2, delay: del);
        self.stopAnimating();
        self.image = checkmark;
        
        // resize for arrow animated image
        var centerPoint = self.center;
        
        switch self.direction {
        case .UP:
            centerPoint.y -= arrow0.size.height / 2.0;
        case .RIGHT:
            centerPoint.x += arrow0.size.height / 2.0;
        case .DOWN:
            centerPoint.y += arrow0.size.height / 2.0;
        case .LEFT:
            centerPoint.x -= arrow0.size.height / 2.0;
        }

        self.frame = CGRect(x: 0.0, y: 0.0, width: checkmark.size.width, height: checkmark.size.height);
        self.center = centerPoint;
        
        fadeIn(duration: dur/2, delay: 0.0);
        isArrow = false;
    }
    
    // replaces the checkmark image with an arrow animation
    func setArrow(duration dur: NSTimeInterval = DEFAULT_DURATION, delay del: NSTimeInterval = DEFAULT_DELAY) {
        if (isArrow) {
            return;
        }
        
        fadeOut(duration: dur/2, delay: del);
        self.animationImages = arrowArray;
        self.startAnimating();
        
        // resize for arrow animated image
        var centerPoint = self.center;
        
        switch self.direction {
        case .UP:
            centerPoint.y += arrow0.size.height / 2.0;
        case .RIGHT:
            centerPoint.x -= arrow0.size.height / 2.0;
        case .DOWN:
            centerPoint.y -= arrow0.size.height / 2.0;
        case .LEFT:
            centerPoint.x += arrow0.size.height / 2.0;
        }
        
        self.frame = CGRect(x: 0.0, y: 0.0, width: arrow0.size.width, height: arrow0.size.height);
        self.center = centerPoint;

        fadeIn(duration: dur/2, delay: 0.0);
        isArrow = true;
    }
    
    // rotates this arrow to the direction in parameter toDirection
    // algorithm: take the additional radians needed to get to up from my current direction (a = 2π - current direction)
    // and add toDirection. Rotate this amount.
    private func rotate(toDirection: ArrowDirection) {
        var startingRadians: CGFloat = 0.0;
        var additionalRadians: CGFloat = 0.0;
        
        // set starting radians
        switch self.direction {
        case .UP:
            startingRadians = 0.0;
        case .RIGHT:
            startingRadians = π/2;
        case .DOWN:
            startingRadians = π;
        case .LEFT:
            startingRadians = 3*π/2;
        }
        
        // set additional radians
        switch toDirection {
        case .UP:
            additionalRadians = 0.0;
        case .RIGHT:
            additionalRadians = π/2;
        case .DOWN:
            additionalRadians = π;
        case .LEFT:
            additionalRadians = 3*π/2;
        }
        additionalRadians += 2*π - startingRadians;
        
        self.transform = CGAffineTransformMakeRotation(startingRadians + additionalRadians);
    }

}
