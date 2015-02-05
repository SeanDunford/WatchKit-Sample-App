//
//  TimerModel.swift
//  BitWatch
//
//  Created by Sean Dunford on 12/6/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import Foundation

var defaultWSecs = 120
var defaultRSecs = 60
var defaultSSecs = 3
var defaultIntervals = 2
public class TimerModel: NSObject {

    private var wsecs: Int = defaultWSecs
    private var rsecs: Int = defaultRSecs
    private var ssecs: Int = defaultSSecs
    private var iAmnt: Int = defaultIntervals
    
    private var wormhole: iWatchMsgController!
    
    private var timersUpdatedCb: (() -> Void)?
    
    private var defaults = NSUserDefaults()
    private var group = "group.tempo"
    
    private var wkey = "work Timer Value"
    private var rkey = "rest Timer Value"
    private var skey = "start Timer Value"
    private var ikey = "interval Count Value"
    
    
    
    public override init() {
        super.init()
        setupNSDefaults()
        getStoredValues()
        //setupKVO()   this didn't seem to be working in swift
        setupWormhole()
    }
    private func setupWormhole(){
        wormhole = iWatchMsgController()
    }
    private func setupKVO(){
        //https://github.com/mutualmobile/MMWormhole
        defaults.addObserver(self, forKeyPath: wkey, options: NSKeyValueObservingOptions.New, context: nil)
        defaults.addObserver(self, forKeyPath: rkey, options: NSKeyValueObservingOptions.New, context: nil)
        defaults.addObserver(self, forKeyPath: skey, options: NSKeyValueObservingOptions.New, context: nil)
        defaults.addObserver(self, forKeyPath: ikey, options: NSKeyValueObservingOptions.New, context: nil)
    }
    public func setTimersUpdatedCb(cb:()->Void){
        timersUpdatedCb = cb
    }
    override public func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        NSLog("Output : \(object) changed property \(keyPath) to value \(change)");
        timersUpdatedCb!()
    }
    private func setupNSDefaults(){
        defaults = NSUserDefaults(suiteName: group)!
    }
    public func update(){
        getStoredValues()
    }
    private func getStoredValues(){
        if(defaults.integerForKey(wkey) == 0){
            return updateStoredValues()
        }
        wsecs = defaults.integerForKey(wkey)
        rsecs = defaults.integerForKey(rkey)
        ssecs = defaults.integerForKey(skey)
        iAmnt = defaults.integerForKey(ikey)     
    }
    private func updateStoredValues(){
        defaults.setInteger(wsecs, forKey: wkey)
        defaults.setInteger(rsecs, forKey: rkey)
        defaults.setInteger(ssecs, forKey: skey)
        defaults.setInteger(iAmnt, forKey: ikey)
        
        defaults.didChangeValueForKey(wkey)
        defaults.didChangeValueForKey(rkey)
        defaults.didChangeValueForKey(skey)
        defaults.didChangeValueForKey(ikey)
        
        defaults.synchronize()
        wormhole.updateWatchTimers()
    }
    public func setWorkSeconds(secs: Int){
        wsecs = (secs > 0 ) ? secs : wsecs
        updateStoredValues()
    }
    public func setRestSeconds(secs: Int){
        rsecs = (secs > 0 ) ? secs : rsecs
        updateStoredValues()
    }
    public func setStartSeconds(secs: Int){
        ssecs = (secs > 0 ) ? secs : ssecs
        updateStoredValues()
    }
    public func setIntervalAmount(amnt: Int){
        iAmnt = (amnt > 0 ) ? amnt :iAmnt
        updateStoredValues()
    }
    public func getRestSeconds()-> Int{
        return rsecs;
    }
    public func getWorkSeconds()-> Int{
        return wsecs;
    }
    public func getStartSeconds()-> Int{
        return ssecs;
    }
    public func getIntervalAmount()-> Int{
        return iAmnt;
    }
    
}