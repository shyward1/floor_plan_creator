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
        
        // init Create Room View and Level View
        createRoomView = CreateRoomView(frame: CGRect(x: 50, y: 0, width: self.view.frame.size.width * 0.75 - 50, height: self.view.frame.size.height));
        levelView = LevelView(frame: CGRect(x: 50, y: self.view.frame.size.width * 0.25, width: self.view.frame.size.width * 0.25 - 50, height: self.view.frame.size.height));
        
        self.view.addSubview(createRoomView);
        self.view.addSubview(levelView);

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        createRoomView.cleanUp();
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