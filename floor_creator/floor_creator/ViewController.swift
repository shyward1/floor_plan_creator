//
//  ViewController.swift
//  floor_creator
//
//  Created by Shy Ward on 10/1/14.
//  Copyright (c) 2014 Shy Ward. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // init Create Room View
        var rect = CGRect(x: 40.0, y: 40.0, width: self.view.frame.size.width/2-40, height: self.view.frame.size.height-80);
        var createRoomView = CreateRoomView(frame: rect);
        
        self.view.addSubview(createRoomView);
    } 

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

