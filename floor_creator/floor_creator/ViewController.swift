//
//  ViewController.swift
//  floor_creator
//
//  Created by Shy Ward on 10/1/14.
//  Copyright (c) 2014 Shy Ward. All rights reserved.
//

import Foundation
import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var measureButton: UIBarButtonItem!

    // View Controller that handles measuring a room
    var measureRoomView: MeasureRoomViewController!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initialize the navigation controller
        self.title = "Floor Plan";
        
        // looks like a pan gesture recognizer can only be associated with 1 view
        let panGestureRec1 = UIPanGestureRecognizer(target: self, action: "gestureRecognizerMethod:");
        let panGestureRec2 = UIPanGestureRecognizer(target: self, action: "gestureRecognizerMethod:");
        
        /// DEBUG
        var r1: Room = Room(x: 400.0, y: 400.0, width: CGFloat(365.76), depth: CGFloat(243.84), name: "Bedroom");
        r1.addGestureRecognizer(panGestureRec1);
        self.view.addSubview(r1);
        
        var r2: Room = Room(x: 100.0, y: 150.0, width: CGFloat(500.0), depth: CGFloat(750.0), name: "Great Room");
        r2.addGestureRecognizer(panGestureRec2);
        self.view.addSubview(r2);
        /// end DEBUG
        
        
    } 

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }

    
// MARK: - View Methods
    
    @IBAction func measureRoom(sender: UIBarButtonItem) {
        let measureRoomVC = MeasureRoomViewController(nibName: nil, bundle: nil);
        navigationController?.pushViewController(measureRoomVC, animated: true);
    }
    
    func gestureRecognizerMethod(recogniser: UIPanGestureRecognizer) {
        if(recogniser.state == UIGestureRecognizerState.Began || recogniser.state == UIGestureRecognizerState.Changed) {
            let touchLocation = recogniser.locationInView(self.view)
            
            if recogniser.view is Room {
                if let theRoom = recogniser.view {
                    theRoom.center = touchLocation;
                }
            }
        }
    }

}

