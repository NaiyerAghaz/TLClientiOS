//
//  TLTimer.swift
//  TLClientApp
//
//  Created by Mac on 17/09/21.
//

import Foundation

class TLTimer {/*<--was named Timer, but since swift 3, NSTimer is now Timer*/
    typealias Tick = ()->Void
    var timer:Timer?
    var interval:TimeInterval /*in seconds*/
    var repeats:Bool
    var tick:Tick

    init(interval:TimeInterval, repeats:Bool = true, onTick:@escaping Tick){
        self.interval = interval
        self.repeats = repeats
        self.tick = onTick
    }
    func start(){
        timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(update), userInfo: nil, repeats: true)//swift 3 upgrade
    }
    func stop(){
        if(timer != nil) {
            timer!.invalidate()
        }
    }
    /**
     * This method must be in the public or scope
     */
    @objc public func update() {
        tick()
    }
}
