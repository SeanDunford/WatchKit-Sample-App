//
//  PriceViewController.swift
//  BitWatch
//
//  Created by Mic Pringle on 19/11/2014.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import UIKit
import BitWatchKit

class PriceViewController: UIViewController {
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    var timer: NSTimer!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    var screenSize: CGRect = UIScreen.mainScreen().bounds;
    var screenWidth = screenSize.width;
    var screenHeight = screenSize.height;
    
    self.timeLabel.adjustsFontSizeToFitWidth = true;
    
    timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("result"), userInfo: nil, repeats: true);
    var obj: Tracker = Tracker()
    var obj2: TimerModel = TimerModel()
    
  }

}
