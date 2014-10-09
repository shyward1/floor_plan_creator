//
//  Util.swift
//  floor_creator
//
//  Created by Mark Reimer on 10/9/14.
//  Copyright (c) 2014 Shy Ward. All rights reserved.
//

import Foundation


///TODO: interrogate iPad to determine screen density and adjust as appropriate
// measurement scale 1' = 30.48 cm = 5 pixels. 1 pixel = 6.096 cm
let SCALE: CGFloat = 6.096;

class Util {
    
    
    class func centimetersToPixels(cm: CGFloat) -> CGFloat {
        return cm/SCALE;
    }
    
    class func pixelsToCentimeters(pixels: CGFloat) -> CGFloat {
        return pixels * SCALE;
    }
    
    
    
}