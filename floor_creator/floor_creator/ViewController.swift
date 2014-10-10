//
//  ViewController.swift
//  floor_creator
//
//  Created by Shy Ward on 10/1/14.
//  Copyright (c) 2014 Shy Ward. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var measureButton: UIBarButtonItem!

    // View Controller that handles measuring a room
    var measureRoomView: MeasureRoomViewController!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initialize the navigation controller
        self.title = "Floor Plan";
        
        
        
        /// DEBUG
        var room: Room = Room(x: 400.0, y: 400.0, width: CGFloat(365.76), depth: CGFloat(243.84), name: "Bedroom");
        self.view.addSubview(room);
        
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

}

