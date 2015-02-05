import Foundation
import BitWatchKit

public class iWatchMsgController: NSObject {
    private var group = "group.tempo"
    private var dir = "wormhole"
    private var wormhole: MMWormhole!
    
    public override init(){
        super.init()
        initialize()
    }
    private func initialize(){
        wormhole = MMWormhole(
            applicationGroupIdentifier: group,
            optionalDirectory: dir)
    }
    public func updateWatchTimers(){
        var msgObject = ["updateTimers":"update"]
        wormhole.passMessageObject(
            msgObject,
            identifier: "updateTimers")
        
        
    }
    
}