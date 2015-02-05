//
//  MainView.swift
//  BitWatch
//
//  Created by Sean Dunford on 1/17/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import Foundation
import UIKit

class ContainerView: UIView{
    var scrollView: UIScrollView!
    var menuOpen: Bool = false
    var disableScrolling = false
    
    
    var width: CGFloat!
    var height: CGFloat!
    
    override init(frame:CGRect){
        super.init(frame:frame)
        width = frame.size.width
        height = frame.size.height
        initialize()
    }
    required init(coder aDeCoder:NSCoder){
        super.init(coder:aDeCoder)
    }
    func initialize(){
        width = self.frame.size.width
        height = self.frame.size.height
        
        scrollView = UIScrollView(frame: self.frame)
        scrollView.contentSize = CGSizeMake((width * 2.0) - 45.0, height);
        scrollView.scrollEnabled = false;
        scrollView.pagingEnabled = false;
        scrollView.backgroundColor = UIColor.whiteColor();
        scrollView.showsHorizontalScrollIndicator = false
        super.addSubview(scrollView)
        
        
        addGestures()
    }
    override func addSubview(view: UIView) {
        scrollView.addSubview(view)
    }
    func addGestures(){
        var swipeRight: UISwipeGestureRecognizer =
            UISwipeGestureRecognizer(target: self, action:"viewWasSwiped:");
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right;
        scrollView.addGestureRecognizer(swipeRight);
        
        var swipeLeft: UISwipeGestureRecognizer =
            UISwipeGestureRecognizer(target: self, action: "viewWasSwiped:");
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left;
        scrollView.addGestureRecognizer(swipeLeft);
    }

    func toggleMenuOpen(){
        if(disableScrolling){return;}
        if( menuOpen ){
            scrollView.setContentOffset(CGPointMake(0, 0), animated: true);
            menuOpen = false;
        } else {
            scrollView.setContentOffset(CGPointMake(width - 45, 0), animated: true);
            menuOpen = true;
        }
    }
    func viewWasSwiped(gesture: UIGestureRecognizer){
        if(disableScrolling){return;}
        self.endEditing(true);
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            if( swipeGesture.direction == UISwipeGestureRecognizerDirection.Right){
                scrollView.setContentOffset(CGPointMake(0, 0), animated: true);
                menuOpen = false;
            } else if( swipeGesture.direction == UISwipeGestureRecognizerDirection.Left ){
                scrollView.setContentOffset(CGPointMake(width - 45, 0), animated: true);
                menuOpen = true;
            }
        }
    }
    
    func menuClicked() {
        toggleMenuOpen()
    }
    
}
