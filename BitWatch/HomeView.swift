//
//  HomeView.swift
//  BitWatch
//
//  Created by Sean Dunford on 1/11/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import UIKit
import BitWatchKit

public class HomeView: UIView {
    var height: CGFloat!
    var width: CGFloat!
    var menuBlock: (() -> ())?
    var beginBlock: (() -> ())?
    
    var SBAR_HEIGHT: CGFloat = 20
    var Y_MARGIN: CGFloat = 30
    var X_MARGIN: CGFloat = 30
    var BTN_SIZE: CGFloat = 60
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        setupUI()
    }
    public func setMenuBlock(block:() -> ()){
        menuBlock = block
    }
    public func setBeginBlock(block:() -> ()){
        beginBlock = block
    }
    func setupUI(){
        height = self.frame.size.height
        width = self.frame.size.width
    
        self.backgroundColor = UIColor.whiteColor()
        
        var menuImage: UIImage! = UIImage(named: "menu-icon");
        var frame =  CGRectMake(X_MARGIN, SBAR_HEIGHT + Y_MARGIN, menuImage.size.width, menuImage.size.height)
        var menuButton: UIButton = UIButton(frame:frame);
        menuButton.setBackgroundImage(menuImage, forState: UIControlState.Normal);
        menuButton.backgroundColor = UIColor.clearColor()
        menuButton.addTarget(self, action: "menuBtnPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        frame = CGRectMake(0, (height * 0.25), width, (height * 0.75 - (height * 0.25)/2) )
        var beginButton: UIButton = UIButton(frame:frame);
        beginButton.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
        beginButton.titleLabel!.font = UIFont(name: "Georgia", size: 60.0)
        beginButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        beginButton.titleEdgeInsets =  UIEdgeInsetsMake(0.0, X_MARGIN, 0.0, 0.0)
        beginButton.setTitle("begin", forState:UIControlState.Normal)
        beginButton.addTarget(self, action: "beginBtnPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.addSubview(beginButton);
        self.addSubview(menuButton);
    }
    func printFonts() {
        //TOD: Helvetica nor Montserrat are included in project see output of function
        let fontFamilyNames = UIFont.familyNames()
        for familyName in fontFamilyNames {
            println("------------------------------")
            println("Font Family Name = [\(familyName)]")
            let names = UIFont.fontNamesForFamilyName(familyName as String)
            println("Font Names = [\(names)]")
        }
    }
    func menuBtnPressed(sender: UIButton){
        menuBlock!()
    }
    func beginBtnPressed(sender: UIButton){
        beginBlock!()
    }
    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}