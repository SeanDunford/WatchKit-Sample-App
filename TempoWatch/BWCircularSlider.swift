//
//  BWCircularSlider.swift
//  TB_CustomControlsSwift
//
//  Created by Yari D'areglia on 03/11/14.
//  Copyright (c) 2014 Yari D'areglia. All rights reserved.
//

import UIKit

struct Config {
    
    static let TB_SLIDER_SIZE:CGFloat = UIScreen.mainScreen().bounds.size.width
    static let TB_SAFEAREA_PADDING:CGFloat = 60.0
    static let TB_LINE_WIDTH:CGFloat = 20.0
    static let TB_HANDLE_CIRCUMFERENCE:CGFloat = 20.0
    static let TB_FONTSIZE:CGFloat = 40.0
    
}


// MARK: Math Helpers 

func DegreesToRadians (value:Double) -> Double {
    return value * M_PI / 180.0
}

func RadiansToDegrees (value:Double) -> Double {
    return value * 180.0 / M_PI
}

func Square (value:CGFloat) -> CGFloat {
    return value * value
}

// MARK: Circular Slider

class BWCircularSlider: UIControl {

    var textField:UILabel?
    var radius:CGFloat = 0
    var angle:CGFloat = 360{
        willSet(x){
        }
    }
    var startColor = UIColor.whiteColor()
    var endColor = UIColor().workPurple()
    var textColor = UIColor.blackColor()
    var maxValue = 3600
    var timeMode = true
    var currValue: CGFloat = 0
    
    // Custom initializer
    convenience init(textColor: UIColor, startColor:UIColor, endColor:UIColor, frame:CGRect){
        self.init(frame: frame)
        
        self.startColor = startColor
        self.endColor = endColor
        self.textColor = textColor
    }
    convenience init(startColor:UIColor, endColor:UIColor, frame:CGRect){
        self.init(frame: frame)
        
        self.startColor = startColor
        self.endColor = endColor
    }
    
    // Default initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.clearColor()
        self.opaque = true
        
        //Define the circle radius taking into account the safe area
        radius = self.frame.size.width/2 - Config.TB_SAFEAREA_PADDING
        
        //Define the Font
        var f = UIFont(name: "Montserrat-Bold", size: Config.TB_FONTSIZE)
        
        if(f == nil){
            f = UIFont(name:"HelveticaNeue", size: Config.TB_FONTSIZE)

        }
        let font = f
        //Calculate font size needed to display 3 numbers
        let str = "000:000" as NSString
        let fontSize:CGSize = str.sizeWithAttributes([NSFontAttributeName:font!])
        

        //Using a TextField area we can easily modify the control to get user input from this field
        let textFieldRect = CGRectMake(
            (frame.size.width  - fontSize.width) / 2.0,
            (frame.size.height - fontSize.height) / 2.0,
            fontSize.width, fontSize.height);
        
        textField = UILabel(frame: textFieldRect)
//        textField?.backgroundColor = UIColor.clearColor()
        textField?.textColor = textColor.colorWithAlphaComponent(0.8)
        textField?.textAlignment = .Center
        textField?.font = font
        textField?.text = "\(self.angle)"
        textField?.userInteractionEnabled = false
        
        addSubview(textField!)
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func beginTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) -> Bool {
        super.beginTrackingWithTouch(touch, withEvent: event)
        println("beginTrackingWithTouch")
        return true
    }
    
    override func cancelTrackingWithEvent(event: UIEvent?){
        println("event cancelled")
        println("cancelling because of event \(event?.description)")
        println("event type \(event?.type)")
        println("event subtype \(event?.subtype)")
        //println("event type \(event?.)")
//        super.cancelTrackingWithEvent(event)
    }
    
    override func continueTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) -> Bool {
        if(!super.continueTrackingWithTouch(touch, withEvent: event)){
            println("super continue tracking failed")
        }
        
        let lastPoint = touch.locationInView(self)
        
        self.moveHandle(lastPoint)
        
        self.sendActionsForControlEvents(UIControlEvents.ValueChanged)
        
        return true
    }
    
    override func endTrackingWithTouch(touch: UITouch, withEvent event: UIEvent) {
        super.endTrackingWithTouch(touch, withEvent: event)
        println("endTrackingWithTouch")
    }
    
    func updateView(
        txtColor: UIColor,
        beginColor: UIColor,
        endColor: UIColor,
        maxValue: CGFloat,
        currValue: CGFloat,
        timeMode: Bool){
        self.textColor = txtColor
        self.startColor = beginColor
        self.endColor = endColor
        self.timeMode = timeMode
        self.maxValue = Int(maxValue)
        
        self.textField?.textColor = txtColor
        
            
        var percent: CGFloat  = (currValue/maxValue)
        self.angle = CGFloat(360 * percent)
    
        updateTextField()
        
        //Redraw
        setNeedsDisplay()
    }
    
    //Use the draw rect to draw the Background, the Circle and the Handle
    override func drawRect(rect: CGRect){
        super.drawRect(rect)
        
        self.textField?.textColor = self.textColor
        let ctx = UIGraphicsGetCurrentContext()
        
        
        /** Draw the Background **/
        
        CGContextAddArc(ctx, CGFloat(self.frame.size.width / 2.0), CGFloat(self.frame.size.height / 2.0), radius, 0, CGFloat(M_PI * 2), 0)
        UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0).set()
        
        CGContextSetLineWidth(ctx, 72)
        CGContextSetLineCap(ctx, kCGLineCapButt)
        
        CGContextDrawPath(ctx, kCGPathStroke)
        
        
        /** Draw the circle **/
        
        /** Create THE MASK Image **/
        UIGraphicsBeginImageContext(CGSizeMake(self.bounds.size.width,self.bounds.size.height));
        let imageCtx = UIGraphicsGetCurrentContext()
        CGContextAddArc(imageCtx, CGFloat(self.frame.size.width/2)  , CGFloat(self.frame.size.height/2), radius, 0, CGFloat(DegreesToRadians(Double(angle))) , 0);
        UIColor.redColor().set()
        
        //Use shadow to create the Blur effect
        CGContextSetShadowWithColor(imageCtx, CGSizeMake(0, 0), CGFloat(self.angle/15), UIColor.whiteColor().CGColor);
       
        //define the path
        CGContextSetLineWidth(imageCtx, Config.TB_LINE_WIDTH)
        CGContextDrawPath(imageCtx, kCGPathStroke)
        
        //save the context content into the image mask
        var mask:CGImageRef = CGBitmapContextCreateImage(UIGraphicsGetCurrentContext());
        UIGraphicsEndImageContext();
        
        /** Clip Context to the mask **/
        CGContextSaveGState(ctx)
        
        CGContextClipToMask(ctx, self.bounds, mask)
        
        
        /** The Gradient **/
        
        // Split colors in components (rgba)
        let startColorComps:UnsafePointer<CGFloat> = CGColorGetComponents(startColor.CGColor);
        let endColorComps:UnsafePointer<CGFloat> = CGColorGetComponents(endColor.CGColor);

        let components : [CGFloat] = [
            startColorComps[0], startColorComps[1], startColorComps[2], 1.0,     // Start color
            endColorComps[0], endColorComps[1], endColorComps[2], 1.0      // End color
        ]
        
        // Setup the gradient
        let baseSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradientCreateWithColorComponents(baseSpace, components, nil, 2)

        // Gradient direction
        let startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect))
        let endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect))
        
        // Draw the gradient
        CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
        CGContextRestoreGState(ctx);
        
        /* Draw the handle */
        drawTheHandle(ctx)

    }
    
    
    
    /** Draw a white knob over the circle **/
    
    func drawTheHandle(ctx:CGContextRef){
        
        CGContextSaveGState(ctx);
        
        //I Love shadows
        CGContextSetShadowWithColor(ctx, CGSizeMake(0, 0), 3, UIColor.whiteColor().CGColor);
        
        //Get the handle position
        var handleCenter = pointFromAngle(Int(angle))

        //Draw It!
        UIColor.blackColor().colorWithAlphaComponent(0.7).set()
        CGContextFillEllipseInRect(ctx, CGRectMake(handleCenter.x, handleCenter.y, Config.TB_HANDLE_CIRCUMFERENCE, Config.TB_HANDLE_CIRCUMFERENCE));
        
        CGContextRestoreGState(ctx);
    }
    
    /** Move the Handle **/

    func moveHandle(lastPoint:CGPoint){
        
        //Get the center
        let centerPoint:CGPoint  = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        //Calculate the direction from a center point and a arbitrary position.
        let currentAngle:Double = AngleFromNorth(centerPoint, p2: lastPoint, flipped: false);
//        let angleInt = Int(floor(currentAngle))

        //Store the new angle
        angle = CGFloat(360 - currentAngle)
  
        updateTextField()
        
        //Redraw
        setNeedsDisplay()
    }
    func updateTextField(){
        //Update the textfield
        var angleInt = Int(floor(Double(angle)))
        var ratio:CGFloat = CGFloat(angleInt)/360.00
        var fRatio: CGFloat = CGFloat(angle)/360.0
        if(timeMode){
            var secs: CGFloat = ratio * CGFloat(maxValue)
            self.currValue = secs
            var m = Int((secs / 60) % 60);
            var s = Int(secs % 60);
            var formattedTime: NSString = String(format: "%02u:%02u", m, s);
            textField!.text = "\(formattedTime)"
        }
        else{
            var intervals = Int(floor(ratio * CGFloat(maxValue)))
            self.currValue = CGFloat(intervals)
            textField!.text = "\(intervals)"
        }
        
    }
    /** Given the angle, get the point position on circumference **/
    func pointFromAngle(angleInt:Int)->CGPoint{
    
        //Circle center
        let centerPoint = CGPointMake(self.frame.size.width/2.0 - Config.TB_LINE_WIDTH/2.0, self.frame.size.height/2.0 - Config.TB_LINE_WIDTH/2.0);

        //The point position on the circumference
        var result:CGPoint = CGPointZero
        let y = round(Double(radius) * sin(DegreesToRadians(Double(-angleInt)))) + Double(centerPoint.y)
        let x = round(Double(radius) * cos(DegreesToRadians(Double(-angleInt)))) + Double(centerPoint.x)
        result.y = CGFloat(y)
        result.x = CGFloat(x)
            
        return result;
    }
    
    
    //Sourcecode from Apple example clockControl
    //Calculate the direction in degrees from a center point to an arbitrary position.
    func AngleFromNorth(p1:CGPoint , p2:CGPoint , flipped:Bool) -> Double {
        var v:CGPoint  = CGPointMake(p2.x - p1.x, p2.y - p1.y)
        let vmag:CGFloat = Square(Square(v.x) + Square(v.y))
        var result:Double = 0.0
        v.x /= vmag;
        v.y /= vmag;
        let radians = Double(atan2(v.y,v.x))
        result = RadiansToDegrees(radians)
        return (result >= 0  ? result : result + 360.0);
    }

}
