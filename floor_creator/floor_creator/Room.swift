//
//  Room.swift
//  Represents a measured room and displays a scaled version of this room.
//
//  floor_creator
//
//  Created by Mark Reimer on 10/9/14.
//  Copyright (c) 2014 Shy Ward. All rights reserved.
//

import UIKit

class Room: UIView {
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
    
    var roomFillColor: UIColor = UIColor.lightGrayColor();
    var roomWallColor: UIColor = UIColor.darkGrayColor();
    
    var lblRoomName: UILabel!
    
    // constructor
    init(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, name: String) {
        super.init();
        
        _roomName = name;
        _roomWidth = width;
        _roomHeight = height;
        _roomDepth = STANDARD_WALL_HEIGHT;
        
        // draw the outer walls
        self.frame = CGRectMake(x, y, width, height);
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = roomWallColor.CGColor;
        self.layer.backgroundColor = roomFillColor.CGColor;
        
        // draw the inner walls inset from the outer walls
        drawWalls();
        
        // add the room name label
        lblRoomName = UILabel();
        lblRoomName.frame = CGRect(x: x, y: y, width: width, height: 20.0);
        lblRoomName.textAlignment = .Center;
        lblRoomName.textColor = UIColor.blackColor();
        self.addSubview(lblRoomName);
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    
    // MARK: - View Methods
    
    func drawWalls() {
        var pxWallDepth: CGFloat = Util.centimetersToPixels(STANDARD_WALL_DEPTH);
        var innerWalls: CGRect = CGRect(x: self.frame.origin.x + pxWallDepth, y: self.frame.origin.y + pxWallDepth, width: self.frame.size.width - 2*pxWallDepth, height: self.frame.size.height - 2*pxWallDepth);
        
        
        var context: CGContextRef = UIGraphicsGetCurrentContext();
        CGContextSetStrokeColorWithColor(context, roomWallColor.CGColor);
        CGContextSetLineWidth(context, 1.0);
        CGContextStrokeRect(context, innerWalls);

    }


    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect)
    {
        // Drawing code
    }
    */

}
