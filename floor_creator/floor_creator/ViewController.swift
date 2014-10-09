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

