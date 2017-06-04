//
//  HammerCurlsExtension.swift
//  Sportakus_2.0
//
//  Created by Jannis Lindenberg on 03.06.17.
//  Copyright © 2017 Jannis Lindenberg. All rights reserved.
//

import WatchKit
import Foundation
import CoreMotion

extension DurchfuehrungInterfaceController {
    
    func countRepsForHammerCurls(){
        motionManager.startDeviceMotionUpdates()
        motionManager.deviceMotionUpdateInterval = 0.1
        var lifted = false
        
        if motionManager.isDeviceMotionAvailable{
            let handler: CMDeviceMotionHandler = {
                (motion: CMDeviceMotion?, error: Error?) -> Void in

                
                let pitch = self.degrees(radians: motion!.attitude.pitch)
                self.wiederholungenLabel.setEnabled(true)
                
                //Try
                if(pitch < -60){
                    if(!lifted){
                        WKInterfaceDevice.current().play(.click)
                    }
                    lifted = true;
                }
                if(pitch > -40 && lifted){
                    lifted = false;
                    self.wiederholung += 1
                    self.wiederholungenLabel.setTitle("\(self.wiederholung)")
                    WKInterfaceDevice.current().play(.failure)
                }
                
                if self.wiederholung == self.zuErreichendeWiederholungen {
                    self.zielErreicht()
                }
                
            }
            motionManager.startDeviceMotionUpdates(to: OperationQueue.current!, withHandler: handler)
        }else{
            
        }
    }
    
    func degrees(radians:Double) -> Double {
        return 180 / .pi * radians
    }
    
}
