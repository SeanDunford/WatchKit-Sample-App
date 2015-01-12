//
//  HomeViewController.swift
//  BitWatch
//
//  Created by Matthew Wagner on 1/10/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import UIKit
import BitWatchKit


class HomeViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()

        let height = self.view.frame.size.height;
        let width = self.view.frame.size.width;
        
        self.view.backgroundColor = UIColor.whiteColor()
        var homeView: HomeView = HomeView(frame: self.view.frame)
        homeView.beginBlock = beginBtnPressed
        homeView.menuBlock = menuBtnPressed
        self.view.addSubview(homeView);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupTimers(){
        var timer: TimerModel! = TimerModel()
        var defaults: NSUserDefaults
        var group = "group.alphastory.bitwatch"
        defaults = NSUserDefaults(suiteName: group)!
        defaults.setObject(timer, forKey:"timer")
    }
    func menuBtnPressed(){
        println("menu Pressed")
    }
    func beginBtnPressed() {
        println("begin Pressed")
    }

}
