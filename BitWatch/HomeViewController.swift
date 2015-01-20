//
//  HomeViewController.swift
//  BitWatch
//
//  Created by Matthew Wagner on 1/10/15.
//  Copyright (c) 2015 Razeware LLC. All rights reserved.
//

import UIKit
import BitWatchKit
import iAd

class HomeViewController: UIViewController, ADBannerViewDelegate, SettingsViewDelegate {
    enum HomeViewControllerState: Int{
        case home = 0
        case work = 1
        case rest = 2
        case settings = 3
    }
    var state: HomeViewControllerState = .home{
        willSet(s){
            switch(s){
            case .home:
                setHomeView()
            case .rest:
                setRestView()
                beginRestCountdown()
            case .work:
                setWorkView()
                beginWorkCountdown()
            case .settings:
                setSettingsView()
            default:
                println("state is " + String(state.rawValue))
            }
        }
    }
    
    var adBannerView: ADBannerView!
    
    var countDownTimer: NSTimer!
    var currentCountDown = 0
    var currentInterval: Int = 0
    var homeCountDown: Int!{
        willSet(i){
            self.homeView.countDown = i
        }
    }
    var restCountDown: Int!{
        willSet(i){
            self.restView.countDown = i
            self.settingsView.restCountDown = i
        }
    }
    var workCountDown: Int!{
        willSet(i){
            self.workView.countDown = i
            self.settingsView.workCountDown = i
        }
    }
    var intervalAmount: Int!{
        willSet(i){
            self.settingsView.intervalAmount = i
        }
    }
    
    //Main Views
    var containerView: ContainerView!
    var homeView: HomeView!
    var workView: WorkView!
    var restView: RestView!
    var settingsView: SettingsView!
    
    //Sizes
    var height: CGFloat!
    var width: CGFloat!
    
    // Colors
    var intervalGreen: UIColor = UIColor().intervalGreen()
    var workPurple: UIColor = UIColor().workPurple()
    var restRed: UIColor = UIColor().restRed()

    func setupIAds(){
        self.canDisplayBannerAds = true;
        self.adBannerView = ADBannerView(frame: CGRectMake(0, height - 50, width, 50));
        self.adBannerView.delegate = self;
        self.adBannerView.hidden = true;
    }
    override init() {
        super.init()
    }
    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        height = self.view.frame.size.height;
        width = self.view.frame.size.width;
        
        setupIAds()
 
        var f: CGRect = CGRectMake(0, 0, width, height - 50)
        containerView = ContainerView(frame: f)
        
        f = CGRectMake(0, 0, width, height)
        homeView = HomeView(frame: f)
        restView = RestView(frame: f)
        workView = WorkView(frame: f)
        
        f = CGRectMake(width, 0, width - 45, height)
        settingsView = SettingsView(frame:f)
        settingsView.delegate = self;
        
        self.state = .home
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(containerView);
        containerView.addSubview(settingsView)
        
        //Replace this with NSUserDefaults
        homeCountDown = 3
        workCountDown = 2
        restCountDown = 1
        intervalAmount = 2
        
        setupViews()
    }
    func setupViews(){
        homeView.countDown = homeCountDown
        homeView.beginBlock = beginHomeCountdown
        
        addMenuButtonToView(homeView)
        addMenuButtonToView(workView)
        addMenuButtonToView(restView)
        
    }
    func increaseState(){
        switch(state){
        case .home:
            self.state = .work
        case .rest:
            self.state = .work
        case .work:
            if(currentInterval++ >= intervalAmount){
                self.state = .home
            }
            else{
                self.state = .rest
            }
        default:
            var str = "can't increment state if it's at state: " + String(state.rawValue)
            println(str)
        }
    }
    func setHomeView(){
        homeView.removeFromSuperview()
        workView.removeFromSuperview()
        restView.removeFromSuperview()
        containerView.addSubview(homeView)
    }
    func setRestView(){
        homeView.removeFromSuperview()
        workView.removeFromSuperview()
        restView.removeFromSuperview()
        containerView.addSubview(restView)
    }
    func setWorkView(){
        homeView.removeFromSuperview()
        workView.removeFromSuperview()
        restView.removeFromSuperview()
        containerView.addSubview(workView)
    }
    func setSettingsView(){
        homeView.removeFromSuperview()
        workView.removeFromSuperview()
        restView.removeFromSuperview()
        containerView.addSubview(settingsView)
    }
    func bannerViewWillLoadAd(banner: ADBannerView!) {
        println("Banner Will Load Ad");
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        println("Banner did load Ad");
        self.adBannerView.hidden = false;
    }
    
    func beginHomeCountdown() {
        homeView.startTimer()
        currentCountDown = homeCountDown
        countDownTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateCountdown"), userInfo: nil, repeats: true)
    }
    
    func beginWorkCountdown(){
        workView.startTimer()
        currentCountDown = workCountDown
        countDownTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateCountdown"), userInfo: nil, repeats: true)
    }
    
    func beginRestCountdown(){
        restView.startTimer()
        currentCountDown = restCountDown
        countDownTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateCountdown"), userInfo: nil, repeats: true)
    }
    
    func updateCountdown() {
        if( currentCountDown - 1 > 0 ){
            currentCountDown--;
            updateTime()
        }
        
        // if we are at 0, reset the countdown, update the label and stop the countdown timer.
        else if( currentCountDown - 1 == 0 ){
            countDownTimer.invalidate();
            stopTimer()
        }
    }
    
    func updateTime(){
        switch(state){
        case .home:
            homeView.updateTime(currentCountDown)
        case .rest:
            restView.updateTime(currentCountDown)
        case .work:
            workView.updateTime(currentCountDown)
        default:
            return
        }
    }
    
    func stopTimer(){
        switch(state){
        case .home:
            increaseState()
            homeView.stopTimer()
        case .rest:
            increaseState()
            restView.stopTimer()
        case .work:
            increaseState()
            workView.stopTimer()
        default:
            return
        }
    }
    
    func scrollToPoint(point: CGPoint) {
        containerView.scrollView.setContentOffset(point, animated: true);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func foo(){
        var timer: TimerModel! = TimerModel()
        var defaults: NSUserDefaults
        var group = "group.alphastory.bitwatch"
        defaults = NSUserDefaults(suiteName: group)!
        defaults.setObject(timer, forKey:"timer")
    }
    func addMenuButtonToView(view: UIView){
        var menuButton: UIButton = UIButton(frame: CGRectMake(width - 35, 10, 25, 25));
        var menuImage: UIImage! = UIImage(named: "menu-icon");
        menuButton.setBackgroundImage(menuImage, forState: UIControlState.Normal);
        menuButton.addTarget(self, action: "menuClicked", forControlEvents: UIControlEvents.TouchUpInside);
        view.addSubview(menuButton);
    }
    func menuClicked(){
        containerView.toggleMenuOpen()
        dismissKeyBoard()
    }
    func dismissKeyBoard(){
        settingsView.workSetting.resignFirstResponder()
        settingsView.restSetting.resignFirstResponder()
        settingsView.intervalSetting.resignFirstResponder()
    }

}
