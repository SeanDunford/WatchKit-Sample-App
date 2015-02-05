//
//  RunningController.swift
//  BitWatch
//
//  Created by Sean Dunford on 12/6/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import Foundation
import WatchKit

class RunningController: WKInterfaceController {
    @IBOutlet weak var runningTimer: WKInterfaceTimer!
    @IBOutlet weak var runningLabel: WKInterfaceLabel!
    var timerObj: TimerModel!
    var workText = "Work!"
    var restText = "Rest"
    var getReadyText = "Get Ready!!2!"
    var state = 0
    
    override init() {
        // Initialize variables here.
        super.init()
        // Configure interface objects here.
        NSLog("%@ init", self)
    }
    override func awakeWithContext(context: AnyObject?) {
        self.timerObj = context as TimerModel
    }
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        NSLog("%@ will activate", self)
        setTimer(-1)
    }
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        NSLog("%@ did deactivate", self)
        super.didDeactivate()
    }
    func setTimer(state: Int){
        switch(state){
            case 0: startWorkTimer()
            case 1: startRestTimer()
            default: startGetReadyTimer()
        }
        runningTimer.start()
    }
    func startGetReadyTimer(){
        var secs = Double(timerObj.getStartSeconds()) + 1
        var d = NSDate().dateByAddingTimeInterval(secs)
        NSTimer.scheduledTimerWithTimeInterval(secs, target: self, selector: Selector("getReadyUpdate"), userInfo: nil, repeats: false)
        runningTimer.setDate(d)
    }
    func startWorkTimer(){
        var secs = Double(timerObj.getWorkSeconds()) + 1
        var wd = NSDate().dateByAddingTimeInterval(secs)
        NSTimer.scheduledTimerWithTimeInterval(secs, target: self, selector: Selector("workUpdate"), userInfo: nil, repeats: false)
        runningTimer.setDate(wd)
    }
    func startRestTimer(){
        var secs = Double(timerObj.getRestSeconds()) + 1
        var rd = NSDate().dateByAddingTimeInterval(secs)
        NSTimer.scheduledTimerWithTimeInterval(secs, target: self, selector: Selector("restUpdate"), userInfo: nil, repeats: false)
        runningTimer.setDate(rd)
    }
    func workUpdate() {
        println("workUpdate")
        setTimer(1)
    }
    func restUpdate() {
        println("restUpdate")
        setTimer(0)
    }
    func getReadyUpdate() {
        println("restUpdate")
        setTimer(0)
    }
}