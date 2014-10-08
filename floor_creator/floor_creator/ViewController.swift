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
    //let ruler: UIImage = UIImage(named: "ruler").imageWithRenderingMode(.AlwaysOriginal);

    var measureRoomView: MeasureRoomViewController!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initialize the navigation controller
        self.title = "Floor Plan";
    
        //measureButton = UIBarButtonItem(image: ruler, style: .Bordered, target: self, action: "measureRoom");
    } 

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning();
    }

    
// MARK: - View Methods
    
    @IBAction func measureRoom(sender: UIBarButtonItem) {
        let measureRoomVC = MeasureRoomViewController(nibName: "MeasureRoomViewController", bundle: nil);
        navigationController?.pushViewController(measureRoomVC, animated: true);
    }

}

