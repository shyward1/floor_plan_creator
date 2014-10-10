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
    var levelView: LevelView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        navigationItem.title = "Measure New Room";
        self.view.layer.borderWidth = 0.0;
        
        // init Create Room View and Level View
        createRoomView = CreateRoomView(frame: CGRect(x: 0.0, y: 65.0, width: self.view.frame.size.width * 0.75, height: self.view.frame.size.height-65.0));
        levelView = LevelView(frame: CGRect(x: self.view.frame.size.width * 0.75, y: 65.0, width: self.view.frame.size.width * 0.25, height: self.view.frame.size.height-65.0));
        
        self.view.addSubview(createRoomView);
        self.view.addSubview(levelView);

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        createRoomView.cleanUp();
        levelView.cleanUp();
        createRoomView = nil;
    }
    
    override func viewWillDisappear(animated: Bool) {
        createRoomView.cleanUp();
        levelView.cleanUp();
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