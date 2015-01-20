//
//  InterfaceController.swift
//  BitWatch WatchKit Extension
//
//  Created by Sean Dunford on 12/4/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import WatchKit
import Foundation


class PausedController: WKInterfaceController {
    @IBOutlet weak var GoButton: WKInterfaceButton!
    var timerObj: TimerModel = TimerModel()
 
    @IBOutlet weak var workTimer: WKInterfaceTimer!
    @IBOutlet weak var restTimer: WKInterfaceTimer!
    
    
    
    
    override init() {
        // Initialize variables here.
        super.init()
        
        // Configure interface objects here.
        NSLog("%@ init", self)
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        NSLog("%@ will activate", self)
        initTimers()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        NSLog("%@ did deactivate", self)
        super.didDeactivate()
    }
    @IBAction func GoButtonPressed() {
//        self.pushControllerWithName("RunningController", context: timerObj)
        self.presentControllerWithName("RunningController", context: timerObj)
    }
    
    func initTimers(){
        workTimer.setDate(NSDate().dateByAddingTimeInterval(timerObj.getWaitSeconds()))
        restTimer.setDate(NSDate().dateByAddingTimeInterval(timerObj.getRestSeconds()))
        workTimer.start()
        workTimer.stop()
        restTimer.start()
        restTimer.stop()
    }
  }
