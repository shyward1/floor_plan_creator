//
//  MeasureRoomViewController.swift
//  floor_creator
//
//  Created by Mark Reimer on 10/8/14.
//  Copyright (c) 2014 Shy Ward. All rights reserved.
//

import UIKit

class MeasureRoomViewController: UIViewController {

    let colorThemeBlue: UIColor = UIColor(red: 26/255.0, green: 126/255.0, blue: 225/255.0, alpha: 1.0);
    
    // UIView for measuring a room
    var createRoomView: CreateRoomView!
    var levelView: LevelView!
    
    let arrow0: UIImage = UIImage(named: "arrow256-0");
    let arrow1: UIImage = UIImage(named: "arrow256-1");
    let arrow2: UIImage = UIImage(named: "arrow256-2");
    let arrow3: UIImage = UIImage(named: "arrow256-3");
    let arrow4: UIImage = UIImage(named: "arrow256-4");
    let arrow5: UIImage = UIImage(named: "arrow256-5");
    let arrow6: UIImage = UIImage(named: "arrow256-6");
    let arrow7: UIImage = UIImage(named: "arrow256-7");
    let arrow8: UIImage = UIImage(named: "arrow256-8");
    let arrow9: UIImage = UIImage(named: "arrow256-9");
    let arrow10: UIImage = UIImage(named: "arrow256-10");
    let arrow11: UIImage = UIImage(named: "arrow256-11");
    let arrow12: UIImage = UIImage(named: "arrow256-12");
    let arrow13: UIImage = UIImage(named: "arrow256-13");
    let arrow14: UIImage = UIImage(named: "arrow256-14");
    let arrow15: UIImage = UIImage(named: "arrow256-15");
    let arrow16: UIImage = UIImage(named: "arrow256-16");
    let arrow17: UIImage = UIImage(named: "arrow256-17");
    let arrow18: UIImage = UIImage(named: "arrow256-18");
    let arrow19: UIImage = UIImage(named: "arrow256-19");
    let arrow20: UIImage = UIImage(named: "arrow256-20");
    let arrow21: UIImage = UIImage(named: "arrow256-21");
    let arrow22: UIImage = UIImage(named: "arrow256-22");
    let arrow23: UIImage = UIImage(named: "arrow256-23");
    let arrow24: UIImage = UIImage(named: "arrow256-24");
    let arrow25: UIImage = UIImage(named: "arrow256-25");
    let arrow26: UIImage = UIImage(named: "arrow256-26");
    let arrow27: UIImage = UIImage(named: "arrow256-27");
    let arrow28: UIImage = UIImage(named: "arrow256-28");
    let arrow29: UIImage = UIImage(named: "arrow256-29");
    let arrow30: UIImage = UIImage(named: "arrow256-30");
    let arrow31: UIImage = UIImage(named: "arrow256-31");
    let arrow32: UIImage = UIImage(named: "arrow256-32");
    let arrow33: UIImage = UIImage(named: "arrow256-33");
    let arrow34: UIImage = UIImage(named: "arrow256-34");
    let arrow35: UIImage = UIImage(named: "arrow256-35");
    let arrow36: UIImage = UIImage(named: "arrow256-36");
    let arrow37: UIImage = UIImage(named: "arrow256-37");
    let arrow38: UIImage = UIImage(named: "arrow256-38");
    let arrow39: UIImage = UIImage(named: "arrow256-39");
    let arrow40: UIImage = UIImage(named: "arrow256-40");
    let arrow41: UIImage = UIImage(named: "arrow256-41");
    let arrow42: UIImage = UIImage(named: "arrow256-42");
    let arrow43: UIImage = UIImage(named: "arrow256-43");
    let arrow44: UIImage = UIImage(named: "arrow256-44");
    let arrow45: UIImage = UIImage(named: "arrow256-45");
    let arrow46: UIImage = UIImage(named: "arrow256-46");
    
    
    var imgView_WalkToRoom: UIImageView!
    var readyButton: UIButton = UIButton();
    var lblHelpText: UILabel = UILabel();
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        navigationItem.title = "Measure New Room";
        self.view.layer.borderWidth = 0.0;
        self.view.backgroundColor = UIColor.whiteColor();
        
        // init Create Room View and Level View
        createRoomView = CreateRoomView(frame: CGRect(x: 0.0, y: 65.0, width: self.view.frame.size.width * 0.75, height: self.view.frame.size.height-65.0));
        createRoomView.parent = self;
        levelView = LevelView(frame: CGRect(x: self.view.frame.size.width * 0.75, y: 65.0, width: self.view.frame.size.width * 0.25, height: self.view.frame.size.height-65.0));
        
        // hide the create room view and level view until the user is in the first room
        createRoomView.hidden = true;
        levelView.hidden = true;

        // display instructions
        let arrowImages: [UIImage] = [arrow0, arrow1, arrow2, arrow3, arrow4, arrow5, arrow6, arrow7, arrow8, arrow9, arrow10,
            arrow11, arrow12, arrow13, arrow14, arrow15, arrow16, arrow17, arrow18, arrow19, arrow20,
            arrow21, arrow22, arrow23, arrow24, arrow25, arrow26, arrow27, arrow28, arrow29, arrow30,
            arrow31, arrow32, arrow33, arrow34, arrow35, arrow36, arrow37, arrow38, arrow39, arrow40,
            arrow41, arrow42, arrow43, arrow44, arrow45, arrow46];
        imgView_WalkToRoom = UIImageView(frame: CGRect(x: self.view.frame.size.width/2.0-arrow0.size.width/2, y: self.view.frame.size.height/2.0-arrow0.size.height/2.0 + 65.0, width: arrow0.size.width, height: arrow0.size.height));
        imgView_WalkToRoom.animationImages = arrowImages;
        imgView_WalkToRoom.animationDuration = 2.0;
        imgView_WalkToRoom.alpha = 0.0;
        self.view.addSubview(imgView_WalkToRoom);
        
        // display the help text
        lblHelpText.frame = CGRect(x: 0.0, y: 150.0, width: self.view.frame.size.width, height: 28.0);
        lblHelpText.textAlignment = NSTextAlignment.Center;
        lblHelpText.textColor = UIColor.grayColor();
        lblHelpText.font = UIFont(name:"Helvetica", size: 20.0);
        lblHelpText.text = "Move to a Room to begin Measuring";
        lblHelpText.alpha = 0.0;
        self.view.addSubview(lblHelpText);
        
        // draw the ready circle button
        readyButton = UIButton.buttonWithType(UIButtonType.Custom) as UIButton;
        readyButton.setTitle("Ready", forState: .Normal);
        readyButton.setTitleColor(colorThemeBlue, forState: .Normal);
        readyButton.titleLabel?.font = UIFont(name:"Helvetica", size: 16.0)
        readyButton.addTarget(self, action: "readyButtonClicked:", forControlEvents: .TouchUpInside);
        readyButton.frame = CGRect(x: 30, y: self.view.frame.size.height/2-1.0, width: 80.0, height: 80.0);
        readyButton.clipsToBounds = true;
        readyButton.layer.cornerRadius = 40.0;
        readyButton.layer.borderColor = colorThemeBlue.CGColor;
        readyButton.layer.borderWidth = 3.0;
        readyButton.alpha = 0.0;
        self.view.addSubview(readyButton);
        
        displayPrepareToMeasureInstructions();
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

    
    // MARK: - View Methods
    
    // called by CreateRoomView UIView after a room has finished measuring
    func didFinishMeasuringRoom() {
        levelView.running = false;
        createRoomView.hidden = true;
        levelView.hidden = true;
        
        displayPrepareToMeasureInstructions();
    }
    
    func displayPrepareToMeasureInstructions() {
        
        // fade in instruction image
        self.imgView_WalkToRoom.hidden = false;
        self.lblHelpText.hidden = false;
        self.imgView_WalkToRoom.startAnimating();
        UIView.animateWithDuration(2.0, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.imgView_WalkToRoom.alpha = 1.0;
            self.lblHelpText.alpha = 1.0;
            }) { (Bool) -> Void in
        }
        
        // fade in ready to measure button
        self.readyButton.hidden = false;
        UIView.animateWithDuration(2.0, delay: 4.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.readyButton.alpha = 1.0;
            }) { (Bool) -> Void in
        }
    }
    
    func readyButtonClicked(sender: UIButton!) {
        // fade out instruction image and ready button
        UIView.animateWithDuration(0.8, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
            self.imgView_WalkToRoom.alpha = 0.0;
            self.readyButton.alpha = 0.0;
            self.lblHelpText.alpha = 0.0;
            }) { (Bool) -> Void in
                self.imgView_WalkToRoom.hidden = true;
                self.readyButton.hidden = true;
                self.lblHelpText.hidden = true;
        }
        
        // display the Create Room View and Level View
        createRoomView.hidden = false;
        levelView.hidden = false;
        levelView.running = true;
        self.view.addSubview(createRoomView);
        self.view.addSubview(levelView);
        
        createRoomView.newRoom();
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