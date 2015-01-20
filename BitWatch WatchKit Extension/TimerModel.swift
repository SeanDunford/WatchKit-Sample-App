//
//  TimerModel.swift
//  BitWatch
//
//  Created by Sean Dunford on 12/6/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

import Foundation

//var defaultWSecs = 901.00
//var defaultRSecs = 301.00
var defaultWSecs = 121.00
var defaultRSecs = 61.00
var defaultSSecs = 3.00
public class TimerModel: NSObject {

    private var wsecs: Double = defaultWSecs
    private var rsecs: Double = defaultRSecs
    private var ssecs: Double = defaultSSecs
    
    public override init() {
        super.init()
    }
    public func setWorkSeconds(secs: Double){
        wsecs = (secs > 0 ) ? secs : wsecs
    }
    public func setRestSeconds(secs: Double){
        rsecs = (secs > 0 ) ? secs : rsecs
    }
    public func setStartSeconds(secs: Double){
        ssecs = (secs > 0 ) ? secs : ssecs
    }
    public func getRestSeconds()-> Double{
        return rsecs;
    }
    public func getWaitSeconds()-> Double{
        return wsecs;
    }
    public func getStartSeconds()-> Double{
        return ssecs;
    }
    
}