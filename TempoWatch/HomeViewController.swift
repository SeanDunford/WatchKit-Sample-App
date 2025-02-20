
import UIKit
import iAd
import TempoSharedFramework
import AVFoundation

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
    
    var audioPlayer:AVAudioPlayer!
    var sound:NSURL!
    
    var adBannerView: ADBannerView!
    var timerObj = TimerModel()
    var countDownTimer: NSTimer!
    var currentCountDown = 0
    var currentInterval: Int = 1
    var totalIntervals: Int = TimerModel().getIntervalAmount();
    var paused = false;
    
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

    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    func monitorDefaults(){
        NSNotificationCenter
            .defaultCenter()
            .addObserver(
                self, selector: "defualtsChanged:",
                name: NSUserDefaultsDidChangeNotification,
                object: nil)
    }
    func defualtsChanged(notification: NSNotification){
        var defaults: NSUserDefaults = notification.object as! NSUserDefaults
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayer = AVAudioPlayer();
        
        monitorDefaults()
        
        height = self.view.frame.size.height;
        width = self.view.frame.size.width;
        
        setupIAds()
 
        var f: CGRect = CGRectMake(0, 0, width, height - 50)
        containerView = ContainerView(frame: f)
        containerView.homeViewSwipedOpen = homeViewSwipedOpen
        containerView.menuViewSwipedOpen = menuViewSwipedOpen
        
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
        
        var x = TimerModel()
        
        homeView.timerObj = self.timerObj
        restView.timerObj = self.timerObj
        workView.timerObj = self.timerObj
        settingsView.timerObj = self.timerObj
        
        workView.pauseCb = togglePauseState
        restView.pauseCb = togglePauseState
        
        setupViews()
    }
    func setupViews(){
        homeView.beginBlock = beginHomeCountdown
        
        addCancelButtonToView(homeView)
        addMenuButtonToView(homeView)
        homeView.hideMenu(false)
        
        addCancelButtonToView(workView)
        addCancelButtonToView(restView)
        
    }
    func togglePauseState(){
        paused = !paused
        containerView.showPauseAnimation(paused)
    }
    func increaseState(){
        switch(state){
        case .home:
            self.state = .work
        case .rest:
            if(currentInterval++ >= timerObj.getIntervalAmount()){
                currentInterval = 1;
                self.state = .home
            }
            else{
                self.state = .work
            }
        case .work:
            self.state = .rest
        default:
            var str = "can't increment state if it's at state: " + String(state.rawValue)
            println(str)
        }
    }
    func setHomeView(){
        if(countDownTimer != nil){
            countDownTimer.invalidate()
        }
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
    
    func menuViewSwipedOpen(){
        homeView.disableButtons = true
    }
    func homeViewSwipedOpen(){
        settingsView.disableButtons = true
    }
    
    func beginHomeCountdown() {
        homeView.hideMenu(true)
        homeView.startTimer()
        currentCountDown = timerObj.getStartSeconds()
        countDownTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateCountdown"), userInfo: nil, repeats: true)
        enableScroll(false)
    }
    
    func beginWorkCountdown(){
        homeView.hideMenu(false)
        playSound("long");
        workView.startTimer()
        workView.updateInterval(currentInterval, total: totalIntervals)
        currentCountDown = timerObj.getWorkSeconds()
        countDownTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateCountdown"), userInfo: nil, repeats: true)
    }
    
    func beginRestCountdown(){
        playSound("long");
        restView.startTimer()
        restView.updateInterval(currentInterval, total: totalIntervals)
        currentCountDown = timerObj.getRestSeconds()
        countDownTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("updateCountdown"), userInfo: nil, repeats: true)
    }
    
    func updateCountdown() {
        if( !paused ){
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
        if( currentCountDown <= 3 && currentCountDown > 0 ){
            playSound("short");
        }
    }
    
    func playSound(soundPath: NSString){
        #if (arch(i386) || arch(x86_64)) && os(iOS)
            //println("is simulator")
        #else
            var filePath:NSString!
            if( soundPath == "short" ){
            filePath = NSBundle.mainBundle().pathForResource("short", ofType: "wav");
            } else if( soundPath == "long" ){
            filePath = NSBundle.mainBundle().pathForResource("long", ofType: "wav");
            }
            
            self.sound = NSURL(fileURLWithPath: filePath as String)
            
            AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil);
            AVAudioSession.sharedInstance().setActive(true, error: nil);
            var error:NSError?
            
            self.audioPlayer = AVAudioPlayer(contentsOfURL: sound, error: &error);
            self.audioPlayer.prepareToPlay();
            self.audioPlayer.play();
        #endif
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

    func enableScroll(enable: Bool){
        self.containerView.disableScrolling = !enable
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func addMenuButtonToView(view: UIView){
        var menuButton: UIButton = UIButton(frame: CGRectMake(width - 35, 10, 25, 25));
        var menuImage: UIImage! = UIImage(named: "menu-icon");
        menuButton.setBackgroundImage(menuImage, forState: UIControlState.Normal);
        menuButton.addTarget(self, action: "menuClicked", forControlEvents: UIControlEvents.TouchUpInside);
        menuButton.tag = 99
        view.addSubview(menuButton);
    }
    func addCancelButtonToView(view: UIView){
        var cancelButton: UIButton = UIButton(frame: CGRectMake(width - 35, 10, 25, 25));
        var cancelImage: UIImage! = UIImage(named: "xbtn");
        cancelButton.setBackgroundImage(cancelImage, forState: UIControlState.Normal);
        cancelButton.addTarget(self, action: "cancelClicked", forControlEvents: UIControlEvents.TouchUpInside);
        cancelButton.tag = 98
        view.addSubview(cancelButton);
    }
    func menuClicked(){
        containerView.toggleMenuOpen()
        dismissKeyBoard()
    }
    
    func cancelClicked(){
        // Reset Interval
        currentInterval = 1;
        // Reset State to 
        homeView.stopTimer()
        homeView.hideMenu(false)
        homeView.disableButtons = false
        paused = false
        self.state = .home
        enableScroll(true)
    }
    
    func dismissKeyBoard(){
        settingsView.workSetting.resignFirstResponder()
        settingsView.restSetting.resignFirstResponder()
        settingsView.intervalSetting.resignFirstResponder()
    }

}
