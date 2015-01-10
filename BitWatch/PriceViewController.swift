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
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    var screenSize: CGRect = UIScreen.mainScreen().bounds;
    var screenWidth = screenSize.width;
    var screenHeight = screenSize.height;
    
    self.timeLabel.adjustsFontSizeToFitWidth = true;
    
    var timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("result"), userInfo: nil, repeats: true);
    
//    view.tintColor = UIColor.blackColor()
//    
//    horizontalLayoutConstraint.constant = 0
//    
//    let originalPrice = tracker.cachedPrice()
//    updateDate(tracker.cachedDate())
//    updatePrice(originalPrice)
//    tracker.requestPrice { (price, error) -> () in
//      if error? == nil {
//        self.updateDate(NSDate())
//        self.updateImage(originalPrice, newPrice: price!)
//        self.updatePrice(price!)
//      }
//    }
  }
  
//  private func updateDate(date: NSDate) {
//    self.dateLabel.text = "Last updated \(Tracker.dateFormatter.stringFromDate(date))"
//  }
//  
//  private func updateImage(originalPrice: NSNumber, newPrice: NSNumber) {
//    if originalPrice.isEqualToNumber(newPrice) {
//      horizontalLayoutConstraint.constant = 0
//    } else {
//      if newPrice.doubleValue > originalPrice.doubleValue {
//        imageView.image = UIImage(named: "Up")
//      } else {
//        imageView.image = UIImage(named: "Down")
//      }
//      horizontalLayoutConstraint.constant = xOffset
//    }
//  }
//  
//  private func updatePrice(price: NSNumber) {
//    self.priceLabel.text = Tracker.priceFormatter.stringFromNumber(price)
//  }
}
