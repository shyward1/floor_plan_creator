//
//  Room.swift
//  Represents a measured room and displays a scaled version of this room.
//
//  floor_creator
//
//  Created by Mark Reimer on 10/9/14.
//  Copyright (c) 2014 Shy Ward. All rights reserved.
//

import Foundation
import UIKit

public class Room: UIView {
    // 92' 5/8"
    let STANDARD_WALL_HEIGHT: CGFloat = 235.268;
    
    // 4"
    let STANDARD_WALL_DEPTH: CGFloat = 10.16;
    
    // what this room is called
    var _roomName: String = "";
    
    // width of the room in centimeters (x axis)
    var _roomWidth: CGFloat = 0.0;
    
    // depth of the room in cm (y axis)
    var _roomDepth: CGFloat = 0.0;
    
    // height of the room in cm (z axis)
    var _roomHeight: CGFloat = 0.0;
    
    //var panGestureRec: UIPanGestureRecognizer!
    
    var roomFillColor: UIColor = UIColor.lightGrayColor();
    var roomWallColor: UIColor = UIColor.darkGrayColor();
    
    var lblRoomName: UILabel!
    
    convenience public init(width: CGFloat, depth: CGFloat, name: String) {
        self.init(x: 0.0, y: 0.0, width: width, depth: depth, name: name);
    }
    
    // constructor
    init(x: CGFloat, y: CGFloat, width: CGFloat, depth: CGFloat, name: String) {
        super.init();
        
        // allow UIPanGestureRecognizer to touch this UIView
        //panGestureRec = UIPanGestureRecognizer(target: self, action: "handleTouches:");
        self.userInteractionEnabled = true;
        //self.addGestureRecognizer(panGestureRec);
        
        _roomName = name;
        _roomWidth = width;
        _roomHeight = STANDARD_WALL_HEIGHT;
        _roomDepth = depth;
        
        // draw the outer walls
        let pxWallDepth: CGFloat = 3.0;
        self.frame = CGRectMake(x, y, Util.centimetersToPixels(width) + 2 * pxWallDepth, Util.centimetersToPixels(depth) + 2 * pxWallDepth);
        self.backgroundColor = UIColor.whiteColor();
        self.layer.borderWidth = 0.0;
        self.layer.borderColor = UIColor.whiteColor().CGColor;
        self.layer.backgroundColor = UIColor.whiteColor().CGColor;
        //self.layer.borderColor = roomWallColor.CGColor;
        //self.layer.backgroundColor = roomFillColor.CGColor;
        
        // add the room name label
        lblRoomName = UILabel();
        lblRoomName.frame = CGRect(x: 0.0, y: self.frame.size.height/2-10.0, width: frame.size.width, height: 20.0);
        lblRoomName.textAlignment = .Center;
        lblRoomName.textColor = UIColor.blackColor();
        lblRoomName.text = _roomName;
        self.addSubview(lblRoomName);
    }
    
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame);
    }
    
    // MARK: - View Methods
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    public override func drawRect(rect: CGRect) {
        //var pxWallDepth: CGFloat = Util.centimetersToPixels(STANDARD_WALL_DEPTH);
        let pxWallDepth: CGFloat = 3.0;
        
        let outerWalls: CGRect = CGRect(x: 0.0, y: 0.0, width: self.frame.size.width, height: self.frame.size.height);
        let innerWalls: CGRect = CGRect(x: pxWallDepth, y: pxWallDepth, width: self.frame.size.width - 2 * pxWallDepth, height: self.frame.size.height - 2 * pxWallDepth);
        
        var context: CGContextRef = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(context, roomWallColor.CGColor);
        CGContextSetLineWidth(context, 0.5);
        CGContextStrokeRect(context, innerWalls);
        CGContextStrokeRect(context, outerWalls);
    }

}
