//
//  RestView.swift
//  BitWatch
//
//  Created by Sean Dunford on 1/17/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import Foundation
import UIKit

public class RestView: UIView{
    var height: CGFloat!
    var width: CGFloat!
    var countDown = 50
    var restTime: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        height = frame.size.height
        width = frame.size.width
        initialize()
    }
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func initialize(){
        var restLabel: UILabel = UILabel(frame: CGRectMake(0, (height * 0.4) - 30, width, 50));
        restLabel.text = "Rest";
        restLabel.font = UIFont(name: "Montserrat-Bold", size: 22);
        restLabel.textColor = UIColor().restRed();
        restLabel.textAlignment = NSTextAlignment.Center;
    
        restTime = UILabel(frame: CGRectMake(0, (height * 0.4), width, 125));
        restTime.text = "99:99";
        restTime.font = UIFont(name: "Montserrat-Bold", size: 100);
        restTime.textColor = UIColor().restRed();
        restTime.textAlignment = NSTextAlignment.Center;

        let settingsWidth = width - 45;
        var settingsView: UIView = UIView(frame: CGRectMake(width, 0, settingsWidth, height));
        settingsView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.02);
        
        self.addSubview(restLabel)
        self.addSubview(restTime)
    }
    func updateTime(secs: Int){
        var m = (secs / 60) % 60;
        var s = secs % 60;
        
        var formattedTime: NSString = String(format: "%02u:%02u", m, s);
        restTime.text = formattedTime
    }
    func startTimer(){
        updateTime(countDown)
    }
    func stopTimer(){
        
    }

}