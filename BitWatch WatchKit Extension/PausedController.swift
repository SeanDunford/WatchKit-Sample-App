//
//  InterfaceController.swift
//  BitWatch WatchKit Extension
//
//  Created by Sean Dunford on 12/4/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import WatchKit
import Foundation
import BitWatchKit

class PausedController: WKInterfaceController {
    @IBOutlet weak var GoButton: WKInterfaceButton!
    var timerObj: TimerModel = TimerModel()
    var wormHole: MMWormhole!
    private var group = "group.tempo"
    private var directory = ""
    
    @IBOutlet weak var workTimer: WKInterfaceTimer!
    @IBOutlet weak var restTimer: WKInterfaceTimer!
    
    
    
    
    override init() {
        // Initialize variables here.
        super.init()
        
        wormHole = MMWormhole(
            applicationGroupIdentifier: group,
            optionalDirectory: "wormhole")
        
        wormHole.listenForMessageWithIdentifier(
            "updateTimers", listener: updateTimers)
        
    }
    func updateTimers(AnyObject!){
        timerObj.update()
        initTimers()
    }
    
    override func willActivate() {
        super.willActivate()
        NSLog("%@ will activate", self)
        
        func monitorDefaults(){
            NSNotificationCenter
                .defaultCenter()
                .addObserver(
                    self, selector: "defualtsChanged:",
                    name: NSUserDefaultsDidChangeNotification,
                    object: nil)
        }
        initTimers()
    }
    func defualtsChanged(notification: NSNotification){
        var defaults: NSUserDefaults = notification.object as NSUserDefaults
        println("notification received")
        initTimers()
    }
    override func didDeactivate() {
        NSLog("%@ did deactivate", self)
        super.didDeactivate()
    }
    @IBAction func GoButtonPressed() {
        self.presentControllerWithName("RunningController", context: timerObj)
    }
    
    func initTimers(){
        workTimer.setDate(NSDate().dateByAddingTimeInterval(Double(timerObj.getWorkSeconds() + 1)))
        restTimer.setDate(NSDate().dateByAddingTimeInterval(Double(timerObj.getRestSeconds() + 1)))
        workTimer.start()
        workTimer.stop()
        restTimer.start()
        restTimer.stop()
    }
  }
