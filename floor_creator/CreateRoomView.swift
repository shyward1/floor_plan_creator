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

    var title: UILabel = UILabel();
    
    let arrowNorth = UIImage(named: "CircleArrow");
    let arrowNorth_on = UIImage(named: "CircleArrow_on");
    let arrowNorthArray: [UIImage]!
    
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
        title.text = "Point towards the first wall to measure it";
        self.addSubview(title);
        
        // draw the arrow images
        /*imgView_arrowNorth = UIImageView(image: arrowNorth);*/
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
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    
    
    
    
    override func drawRect(rect: CGRect) {

    }

    
    
}