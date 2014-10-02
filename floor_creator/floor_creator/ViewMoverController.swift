//
//  ViewMoverController.swift
//  floor_creator
//
//  Created by Shy Ward on 10/2/14.
//  Copyright (c) 2014 Shy Ward. All rights reserved.
//

import Foundation
import UIKit

class ViewMoverController : UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //your stuff here
        
        //initialize your UIImageView
        var image : UIImage = UIImage(named:"women")
        imageView.image = image;
        imageView.userInteractionEnabled = true
        
        //let panGestureRec = UIPanGestureRecognizer(target: self, action: gestureRecognizerMethod)
        let panGestureRec = UIPanGestureRecognizer(target: self, action: "gestureRecognizerMethod:")
        
        imageView.addGestureRecognizer(panGestureRec)
        
    }

    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        var touch: AnyObject? = event.allTouches()?.anyObject()
        if(touch?.view == imageView)
        {
            let location = touch?.locationInView(self.view)
            imageView.center = location!;
        }

    }
    
    func gestureRecognizerMethod(recogniser: UIPanGestureRecognizer)
    {
        if(recogniser.state == UIGestureRecognizerState.Began || recogniser.state == UIGestureRecognizerState.Changed)
        {
            let touchLocation = recogniser.locationInView(self.view)
            imageView.center = touchLocation
        }
    }
}
