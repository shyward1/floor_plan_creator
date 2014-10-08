//
//  MeasureRoomViewController.swift
//  floor_creator
//
//  Created by Mark Reimer on 10/8/14.
//  Copyright (c) 2014 Shy Ward. All rights reserved.
//

import UIKit

class MeasureRoomViewController: UIViewController {

    // UIView for measuring a room
    var createRoomView: CreateRoomView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        navigationItem.title = "Measure New Room";
        
        // init Create Room View
        var rect = CGRect(x: 50, y: 0, width: self.view.frame.size.width * 0.75 - 50, height: self.view.frame.size.height);
        createRoomView = CreateRoomView(frame: rect);
        self.view.addSubview(createRoomView);

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        createRoomView = nil;
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}